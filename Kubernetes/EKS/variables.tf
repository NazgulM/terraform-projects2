variable "region" {
	type = string
	description = "Provide region"
}
variable "cluster_name" {
	type = string
	description = "Provide cluster name"
}
variable "cluster_version" {
	default = "1.22"
	description = "Provide cluster version"
}
variable "instance_type" {
	description = "Provide instance type"
	type = string
}
variable "asg_max_size" {
	description = "Set maximum number of nodes"
	type = string
}
variable "asg_min_size" {
	description = "Set minimum number of nodes"
	type = string
}
variable "tags" {
	description = "Provide tags"
	type = map(any)
}