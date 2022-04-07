data "aws_s3_bucket" "source_bucket" {
  bucket = "taufort-06042022-source"
}

data "aws_s3_bucket" "target_bucket" {
  bucket = "taufort-06042022-target"
}
