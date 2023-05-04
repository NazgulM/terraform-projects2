output ami {
  value = aws_instance.web.ami
}

output arn {
  value = aws_instance.web.arn
}

output instance_type {
  value = aws_instance.web.instance_type
}

output public_ip {
  value = aws_instance.web.public_ip
}