# VPC Configuration
resource "aws_vpc" "nagios_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Internet Gateway Configuration
resource "aws_internet_gateway" "nagios_gateway" {
  vpc_id = aws_vpc.nagios_vpc.id
}

# Public Subnet Configuration
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.nagios_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

# Private Subnet Configuration
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.nagios_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"
}

# Route Table Configuration
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.nagios_vpc.id
}

# Route Configuration
resource "aws_route" "public_internet_gateway_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.nagios_gateway.id
}

# Associate Route Table with Public Subnet
resource "aws_route_table_association" "public_route_table_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

# EC2 Instance Configuration
resource "aws_instance" "nagios_instance" {
  ami                         = "ami-0aa2b7722dc1b5612"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_subnet.id
  associate_public_ip_address = true

  user_data = <<-EOF
#!/bin/bash
NAGIOS_ADMIN_PASSWORD="adminadmin"
sudo apt update -y
sudo apt install -y autoconf bc gawk dc build-essential gcc libc6 make wget unzip apache2 php libapache2-mod-php libgd-dev libmcrypt-dev make libssl-dev snmp libnet-snmp-perl gettext
wget https://github.com/NagiosEnterprises/nagioscore/archive/nagios-4.4.6.tar.gz
tar -xf nagios-4.4.6.tar.gz
cd nagioscore-*/
sudo ./configure --with-httpd-conf=/etc/apache2/sites-enabled
sudo make all
sudo make install-groups-users
sudo usermod -a -G nagios www-data
sudo make install
sudo make install-daemoninit
sudo make install-commandmode
sudo make install-config
sudo make install-webconf
sudo a2enmod rewrite cgi
systemctl restart apache2
sudo htpasswd -b -c /usr/local/nagios/etc/htpasswd.users nagiosadmin "$NAGIOS_ADMIN_PASSWORD"
for svc in Apache ssh
do
sudo ufw allow $svc
done
yes | sudo ufw enable
sudo ufw status numbered
sudo apt install monitoring-plugins nagios-nrpe-plugin -y 
cd /usr/local/nagios/etc
sudo mkdir -p /usr/local/nagios/etc/servers
# vim nagios.cfg
# cfg_dir=/usr/local/nagios/etc/servers
# vim resource.cfg
# $USER1$=/usr/lib/nagios/plugins
# vim objects/contacts.cfg
# define contact{
#         ......
#         email             email@host.com
# }
# vim objects/commands.cfg
# define command{
#         command_name check_nrpe
#         command_line $USER1$/check_nrpe -H $HOSTADDRESS$ -c $ARG1$
# }
sudo systemctl start nagios
sudo systemctl enable nagios
sudo systemctl status nagios
sudo sed "$(grep -n "AllowOverride None" /etc/apache2/apache2.conf |cut -f1 -d:)s/.*/AllowOverride All/" /etc/apache2/apache2.conf > apache.txt
sudo systemctl restart apache2
EOF

  user_data_replace_on_change = true
  security_groups             = [aws_security_group.nagios_security_group.id]

  tags = {
    Name = "nagios_instance"
  }

  # Security Group Configuration
  vpc_security_group_ids = [
    aws_security_group.nagios_security_group.id,
  ]
}

# Security Group Configuration
resource "aws_security_group" "nagios_security_group" {
  name_prefix = "nagios_security_group"
  vpc_id      = aws_subnet.public_subnet.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
