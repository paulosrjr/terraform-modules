resource "aws_iam_role_policy" "this" {
  name = "${var.env}-bastion"
  role = aws_iam_role.this.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:*",
        "cloudwatch:*",
        "ec2:*,
        "events:*",
        "kms:ListAliases",
        "lambda:*",
        "logs:*",
        "s3:*"
      ],
      "Resource": "*"
    }
  ]
}
EOF  
}

resource "aws_iam_role" "this" {
  name = "${var.env}-bastion"
  path = "/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "this" {
  name = "${var.env}-bastion"
  role = aws_iam_role.this.name
}
