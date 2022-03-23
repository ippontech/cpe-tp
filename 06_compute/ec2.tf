data "aws_ami" "amazon_linux_2_ami" {
  most_recent = true
  name_regex  = "^amzn2-ami-hvm-[\\d.]+-x86_64-gp2$"
  owners      = ["amazon"]
}

data "aws_iam_instance_profile" "ssm_instance_profile" {
  name = "LabInstanceProfile"
}

resource "aws_security_group" "ssh" {
  name        = "${var.project}-ssh-access"
  description = "SSH"
  vpc_id = aws_vpc.main.id

  egress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
}
