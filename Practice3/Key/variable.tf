variable "region" {
    description  =  "Enter the region"
    type = string
    default = "us-east-2"
}

variable "key_name" {
    description = "Enter key name"
    type = string
    default = "ohio_key"
}

variable "key_file" {
    description = "Enter public key location"
    type = string
    default = "~/.ssh/id_rsa.pub"
}