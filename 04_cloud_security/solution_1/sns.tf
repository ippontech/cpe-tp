data "aws_caller_identity" "current" {}

resource "random_string" "topic_name_suffix" {
  length    = 10
  special   = false
  min_lower = 10
}

locals {
  topic_name = "${var.school}-${random_string.topic_name_suffix.result}"
}

resource "aws_sns_topic" "default" {
  name         = local.topic_name
  display_name = "CPE default topic"

  # Encryption with a default AWS managed AWS KMS key
  # Note: On the sandbox environment, our assumed role does not have 'kms:DescribeKey' action, as a result, if we
  # activate encryption, we get a 403 error when trying to access the SNS topic through the AWS console
  # kms_master_key_id = "alias/aws/sns"

  # Inlined policy
  policy = <<EOF
{
  "Version": "2008-10-17",
  "Id": "CPEDefaultTopicPolicy",
  "Statement": [
    {
      "Sid": "DenyPublishRole",
      "Effect": "Deny",
      "Principal": {
        "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/voclabs"
      },
      "Action": [
        "SNS:Publish"
      ],
      "Resource": "arn:aws:sns:${var.region}:${data.aws_caller_identity.current.account_id}:${local.topic_name}"
    }
  ]
}
EOF
}
