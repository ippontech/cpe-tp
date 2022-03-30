resource "aws_vpc" "main" {
  cidr_block           = "10.1.0.0/21"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project}-vpc"
  }
}
