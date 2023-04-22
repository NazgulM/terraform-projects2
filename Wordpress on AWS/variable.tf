variable "ami_id" {
    description = "AMI ID to use"
    default = "ami-0b5eea76982371e91"
}

variable "instance_type" {
    description = "Instance type to use"
    default = "t2.micro"
}

variable "name" {
    description = "Name to use"
    default = "my_instance"
}

variable "key_name" {
    description = "Key pair name to use"
    default = "my_key_pair"
}