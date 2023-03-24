data "aws_ami" "amazon_linux_2_ami" {
  most_recent = true
  name_regex  = "^amzn2-ami-hvm-[\\d.]+-x86_64-gp2$"
  owners      = ["amazon"]
}

data "aws_iam_instance_profile" "ssm_instance_profile" {
  name = "LabInstanceProfile"
}

resource "aws_security_group" "ssh_security_group" {
  name        = "${var.project}-ssh-security-group"
  description = "SSH access"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project}-ssh-security-group"
  }
}

resource "aws_vpc_security_group_egress_rule" "ssh_security_group_egress_rule" {
  security_group_id = aws_security_group.ssh_security_group.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}
