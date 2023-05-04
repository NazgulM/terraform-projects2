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

  tags  = {
    Name  = var.vpc_name
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
  user_data = <<-EOF
#!/bin/bash
echo "hello world"
EOF

  tags  = {
    Name = "nagios_instance"
  }

}

