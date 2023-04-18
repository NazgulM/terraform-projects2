resource "aws_iam_user" "lb" {
  name = "kaizen"
}

resource "aws_iam_group" "devops" {
  name = "devops"
}