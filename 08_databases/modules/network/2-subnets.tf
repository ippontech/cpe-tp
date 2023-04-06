resource "aws_subnet" "public_subnet_a" {
  availability_zone       = local.az_a
  cidr_block              = "10.0.0.0/19"
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project}-public-subnet-a"
  }
}

resource "aws_subnet" "public_subnet_b" {
  availability_zone       = local.az_b
  cidr_block              = "10.0.32.0/19"
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project}-public-subnet-b"
  }
}

resource "aws_subnet" "public_subnet_c" {
  availability_zone       = local.az_c
  cidr_block              = "10.0.64.0/19"
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project}-public-subnet-c"
  }
}

resource "aws_subnet" "private_subnet_a" {
  availability_zone = local.az_a
  cidr_block        = "10.0.96.0/19"
  vpc_id            = aws_vpc.vpc.id

  tags = {
    Name = "${var.project}-private-subnet-a"
  }
}

resource "aws_subnet" "private_subnet_b" {
  availability_zone = local.az_b
  cidr_block        = "10.0.128.0/19"
  vpc_id            = aws_vpc.vpc.id

  tags = {
    Name = "${var.project}-private-subnet-b"
  }
}

resource "aws_subnet" "private_subnet_c" {
  availability_zone = local.az_c
  cidr_block        = "10.0.160.0/19"
  vpc_id            = aws_vpc.vpc.id

  tags = {
    Name = "${var.project}-private-subnet-c"
  }
}
