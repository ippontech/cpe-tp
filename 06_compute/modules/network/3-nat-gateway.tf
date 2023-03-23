resource "aws_eip" "nat_gateway_a_eip" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gateway_a" {
  allocation_id = aws_eip.nat_gateway_a_eip.id
  subnet_id     = aws_subnet.public_subnet_a.id

  tags = {
    Name = "${var.project}-nat-gateway-a"
  }

  depends_on = [
    aws_internet_gateway.internet_gateway
  ]
}
