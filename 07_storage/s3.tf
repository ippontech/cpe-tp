data "aws_s3_bucket" "source_bucket" {
  bucket = var.bucket_source
}

data "aws_s3_bucket" "target_bucket" {
  bucket = var.bucket_target
}
