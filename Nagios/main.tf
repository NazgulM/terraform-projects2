# Create a VPC with two subnets

resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "subnet_1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_subnet" "subnet_2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.2.0/24"
}

# Create an internet gateway and attach it to the VPC
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}

# Create a route table and associate it with the subnets
resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "route_table_association_1" {
  subnet_id      = aws_subnet.subnet_1.id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_route_table_association" "route_table_association_2" {
  subnet_id      = aws_subnet.subnet_2.id
  route_table_id = aws_route_table.route_table.id
}

# Launch an EC2 instance with user_data to install Nagios
resource "aws_instance" "instance" {
  ami           = "ami-007855ac798b5175e"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet_1.id

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install nagios3 -y
              EOF

  tags = {
    Name = "Nagios-EC2"
  }

  # Allocate a public IP address for the instance
  associate_public_ip_address = true

  # Open port 80 to allow HTTP traffic
  security_groups = [aws_security_group.security_group.id]
}

# Create a security group to allow HTTP traffic
resource "aws_security_group" "security_group" {
  name_prefix = "security_group"
  vpc_id      = aws_subnet.subnet_1.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

