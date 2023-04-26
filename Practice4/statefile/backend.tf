terraform {
  backend "s3" {
    bucket = "nazgul-bucket-practice4"
    key    = "path/to/my/key"
    region = "us-east-1"
    dynamodb_table = "lock-state"
  }
}
