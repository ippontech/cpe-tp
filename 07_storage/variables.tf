variable "region" {
  type    = string
  default = "us-east-1"
}

variable "school" {
  type    = string
  default = "cpe"
}

variable "project" {
  type    = string
  default = "07-storage"
}

# TODO: update the S3 bucket names below with your bucket names
variable "bucket_source" {
  type    = string
  default = "taufort-06042022-source"
}

variable "bucket_target" {
  type    = string
  default = "taufort-06042022-target"
}
