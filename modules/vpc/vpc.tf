resource "aws_vpc" "main" {
  cidr_block           = "10.1.0.0/21"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project}-vpc"
  }
}

locals {
  az_a = "${var.region}a"
  az_b = "${var.region}b"
  az_c = "${var.region}c"
}

resource "aws_subnet" "public_a" {
  cidr_block              = "10.1.0.0/24"
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = true
  availability_zone       = local.az_a

  tags = {
    Name = "${var.project}-public-a"
  }
}

resource "aws_subnet" "public_b" {
  cidr_block              = "10.1.1.0/24"
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = true
  availability_zone       = local.az_b

  tags = {
    Name = "${var.project}-public-b"
  }
}

resource "aws_subnet" "public_c" {
  cidr_block              = "10.1.2.0/24"
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = true
  availability_zone       = local.az_c

  tags = {
    Name = "${var.project}-public-c"
  }
}

resource "aws_subnet" "private_a" {
  cidr_block        = "10.1.4.0/24"
  vpc_id            = aws_vpc.main.id
  availability_zone = local.az_a

  tags = {
    Name = "${var.project}-private-a"
  }
}

resource "aws_subnet" "private_b" {
  cidr_block        = "10.1.5.0/24"
  vpc_id            = aws_vpc.main.id
  availability_zone = local.az_b

  tags = {
    Name = "${var.project}-private-b"
  }
}

resource "aws_subnet" "private_c" {
  cidr_block        = "10.1.6.0/24"
  vpc_id            = aws_vpc.main.id
  availability_zone = local.az_c

  tags = {
    Name = "${var.project}-private-c"
  }
}
