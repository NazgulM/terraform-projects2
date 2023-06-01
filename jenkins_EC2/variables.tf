variable "aws_region" {
  default = "us-east-1"
  type    = string
}

variable "ami" {
  default = "ami-0715c1897453cabd1"
  type    = string
}

variable "instance_type" {
  default = "t2.micro"
  type    = string
}

variable "key_name" {
  default = "levelupkeypair"
  type    = string
}

variable "associate_public_ip_address" {
  default = "true"
  type    = bool
}

variable "jenkins-tag-name" {
  default = "Jenkins-Server"
  type    = string
}

variable "bucket" {
  default = "jenkins-s3-bucket-nazgul-m"
  type    = string
}

variable "acl" {
  default = "private"
  type    = string
}

variable "key_file" {
  description = "Enter public key location"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}