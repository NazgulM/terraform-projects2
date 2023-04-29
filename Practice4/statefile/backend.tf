terraform {
  backend "s3" {
    bucket = "kaizen-bucket-class4"
    key    = "path/to/my/key"
    region = "us-east-1"
    dynamodb_table = "lock-state"
  }
}