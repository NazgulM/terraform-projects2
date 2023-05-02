variable "region" {
  type        = string
  description = "Enter AWS region"
  default     = "us-east-1"
}

variable "vpc_name" {
   type        = string
   description = "Enter the name of VPC"
   default     = "nagios_vpc"
}

variable "cidr_block" {
    description = "Enter cidr block"
    type = string
    default = "10.0.0.0/16"
}

variable "public_subnet" {
    description = "Enter private subnets"
    type = string 
    default = "nagios_vpc_public_subnet"

}

variable "public_subnet_cidr_block" {
    description = "Enter the public subnet cidr_block"
    type         = string
    default      = "10.0.1.0/24"
}

variable "public_subnet_az" {
    description = "Enter the AZ"
    type        = string
    default     = "us-east-1a"
}

variable "private_subnet" {
    description = "Enter private subnet"
    type = string
    default = "nagios_vpc_private_subnet"
}

variable "private_subnet_cidr_block" {
    description = "Enter the private subnet cidr_block"
    type         = string
    default      = "10.0.2.0/24"
}

variable "private_subnet_az" {
    description = "Enter the AZ"
    type        = string
    default     = "us-east-1a"
}


variable "key_name" {
    description = "Enter key name"
    type = string
    default = "devops_key"
}

variable "key_file" {
    description = "Enter public key location"
    type = string
    default = "~/.ssh/id_rsa.pub"
}

variable "ami_id" {
    description = "Enter the ami id"
    type        = string
    default     = "ami-02396cdd13e9a1257"
}

variable "instance_type" {
    description = "Enter the instance type"
    type        = string
    default     = "t2.micro"
}
