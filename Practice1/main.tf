resource "aws_iam_user" "lb" {
  name = "kaizen"
}


resource "aws_iam_user" "lb1" {
  name = each.key
  for_each = toset([
    "user",
    "user1",
    "user2"
  ])
}


resource "aws_iam_group" "devops" {
  name = "devops"
}


resource "aws_iam_group_membership" "team" {
  name = "tf-testing-group-membership"

  users = [
    aws_iam_user.lb.name,
  ]

  group = aws_iam_group.devops.name
}


resource "aws_key_pair" "devops" {
  key_name   = "devops-key"
  public_key = file("~/.ssh/id_rsa.pub")
}


resource "aws_s3_bucket" "example" {
  bucket_prefix = "nazgul"
}

