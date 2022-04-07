resource "aws_sns_topic" "s3_notification_topic" {
  name         = "s3-notification-${var.project}"
  display_name = "S3 notification topic"
}
