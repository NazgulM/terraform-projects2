variable "instance_name" {
    type = string
    description = "Enter instance name"
    default = "nazgul"
}

variable "machine_type" {
    type  = string
    description = "Enter machine type"
    default = "e2-medium"
}

variable "zone" {
    type = string
    description = "Enter zone"
    default = "us-central1-a"
}

variable "billing" {
    type = string
    description = "enter the billing id"
    default = "011462-637D2F-B9F59E"
}

variable "project_id" {
    type = string
    description = "Enter the project id"
    default = "nazgul-2023"
}

