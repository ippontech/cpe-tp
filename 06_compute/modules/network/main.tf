terraform {
  required_version = "~> 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

locals {
  az_a = "${var.region}a"
  az_b = "${var.region}b"
  az_c = "${var.region}c"
}
