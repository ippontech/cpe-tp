resource "random_string" "topic_name_suffix" {
  length    = 10
  special   = false
  min_lower = 10
}

resource "aws_sns_topic" "default" {
  name = "${var.school}-${random_string.topic_name_suffix.result}"
  display_name = "CPE default topic"
}
