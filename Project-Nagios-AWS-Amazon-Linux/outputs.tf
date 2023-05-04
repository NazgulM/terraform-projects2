# Output the instance public IP address
output "instance_public_ip" {
  value = aws_instance.nagios_instance.public_ip
}