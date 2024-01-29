data "aws_iam_policy" "dynamodb" {
  name = "AmazonDynamoDBFullAccess"
}

resource "aws_iam_role" "fiap" {
  name               = "auth0-lambda-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "dynamodb" {
  role       = "${aws_iam_role.fiap.name}"
  policy_arn = "${data.aws_iam_policy.dynamodb.arn}"
}