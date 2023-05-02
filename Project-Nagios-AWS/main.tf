# Create a VPC
resource "aws_vpc" "nagios_vpc" {
  cidr_block = var.cidr_block

  tags = {
    Name = var.vpc_name
  }
}

# Create subnets for different parts of the infrastructure
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.nagios_vpc.id
  cidr_block        = var.public_subnet_cidr_block
  availability_zone = var.public_subnet_az

  tags = {
    Name = var.public_subnet
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.nagios_vpc.id
  cidr_block        = var.private_subnet_cidr_block
  availability_zone = var.private_subnet_az

  tags = {
    Name = var.private_subnet
  }
}

# Attach an internet gateway to the VPC

resource "aws_internet_gateway" "nagios_vpc_ig" {
  vpc_id = aws_vpc.nagios_vpc.id

  tags = {
    Name = "Nagios_VPC_IG"
  }
}

# Create a route table for a public subnet

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.nagios_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.nagios_vpc_ig.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.nagios_vpc_ig.id
  }

  tags = {
    Name = "Public Route Table"
  }
}

# Route Table association

resource "aws_route_table_association" "public_1_rt_a" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# Create security group

resource "aws_security_group" "web_sg" {
  name   = "HTTP and SSH"
  vpc_id = aws_vpc.nagios_vpc.id

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
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "devops" {
  key_name   = var.key_name
  public_key = file(var.key_file)
}

# Create AWS EC2 instance

  resource "aws_instance" "nagios_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  associate_public_ip_address = true
  user_data = <<EOF
		    #!/bin/bash
        yum install httpd php wget -y
        yum install gcc glibc glibc-common -y
        yum install gd gd-devel openssl-devel -y

        # Add a user for nagios and password for it..
        adduser -m nagios
        passwd nagios

       # Create a user-group and nagios and apache users to it
       groupadd nagioscmd
       usermod -a -G nagioscmd nagios
       usermod -a -G nagioscmd apache

       # Download the tarball for Nagios Core and Nagios Plugins
       mkdir downloads
       cd downloads
       wget http://prdownloads.sourceforge.net/sourceforge/nagios/nagios-4.4.10.tar.gz
       wget http://nagios-plugins.org/download/nagios-plugins-2.4.3.tar.gz

      # Extract & build the tarball to Nagios Core
      tar zxvf nagios-4.4.10.tar.gz
      cd nagios-4.4.10
      ./configure --with-command-group=nagioscmd
      make all
      make install
      make install-init
      make install-config
              make install-commandmode
              make install-webconf

             # Create a username and password to access the WebUI of Nagios - Here "nagiosadmin" is username to be created
             htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin

              # Restart the httpd service to take effect
              service httpd restart

              # Now, Let's extract and build the Nagios plugins for Core
              cd ~/downloads
              tar zxvf nagios-plugins-2.4.3.tar.gz
              cd nagios-plugins-2.4.3
              ./configure --with-nagios-user=nagios --with-nagios-group=nagios
               make
               make install

               # Check whether the confir files are good to go
               chkconfig --add nagios
               chkconfig nagios on

               # Check whether config files have some errors are not
               /usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg

                # Run the Nagios service and then restart the httpd server.
                service nagios start
                service httpd restart


                 ##    Visit : "http://<IP-Address>/nagios"  to access the WebUI by entering the above entered username and password...
  EOF
}

