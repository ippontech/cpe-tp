resource "aws_sns_topic" "s3_notification_topic" {
  name         = "${var.project}-s3-notification"
  display_name = "S3 notification topic"
}
