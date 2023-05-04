provider "aws" {
  region = "us-east-2"
}

# Create VPC and subnets
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "my_subnet_1" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_subnet" "my_subnet_2" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.2.0/24"
}

# Create internet gateway and attach to VPC
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
}

# Create route tables and associate with subnets
resource "aws_route_table" "my_rt_1" {
  vpc_id = aws_vpc.my_vpc.id
}

resource "aws_route_table_association" "my_rta_1" {
  subnet_id      = aws_subnet.my_subnet_1.id
  route_table_id = aws_route_table.my_rt_1.id
}

resource "aws_route" "my_route_1" {
  route_table_id         = aws_route_table.my_rt_1.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_igw.id
}

resource "aws_route_table" "my_rt_2" {
  vpc_id = aws_vpc.my_vpc.id
}

resource "aws_route_table_association" "my_rta_2" {
  subnet_id      = aws_subnet.my_subnet_2.id
  route_table_id = aws_route_table.my_rt_2.id
}

resource "aws_route" "my_route_2" {
  route_table_id         = aws_route_table.my_rt_2.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_igw.id
}

# Create EC2 instance in subnet 1
resource "aws_instance" "my_ec2" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.my_subnet_1.id
  associate_public_ip_address = true

  # User data to install Nagios4 and open necessary ports
  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install -y nagios4
              sudo ufw allow 22
              sudo ufw allow 80
              sudo ufw allow 443
              sudo systemctl enable nagios4
              sudo systemctl start nagios4
              EOF

  # Security group to allow SSH and HTTP traffic
  vpc_security_group_ids = [aws_security_group.my_sg.id]
}

# Security group to allow SSH and HTTP traffic
resource "aws_security_group" "my_sg" {
  name_prefix = "my_sg"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
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