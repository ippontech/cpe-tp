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
}

resource "aws_sns_topic_policy" "default" {
  arn    = aws_sns_topic.default.arn
  policy = data.aws_iam_policy_document.default_sns_topic_policy.json
}

data "aws_iam_policy_document" "default_sns_topic_policy" {
  policy_id = "CPEDefaultTopicPolicy"

  statement {
    sid = "DenyPublishRole"

    effect = "Deny"

    actions = [
      "SNS:Publish",
    ]

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/voclabs"
      ]
    }

    resources = [
      aws_sns_topic.default.arn,
    ]
  }
}
