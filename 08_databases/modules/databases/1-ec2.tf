data "aws_ami" "amazon_linux_2_ami" {
  most_recent = true
  name_regex  = "^amzn2-ami-hvm-[\\d.]+-x86_64-gp2$"
  owners      = ["amazon"]
}

data "aws_iam_instance_profile" "ssm_instance_profile" {
  name = "LabInstanceProfile"
}

# TODO STEP 7: Choose a subnet for your instance, add a Security Group to it and complete the user data to pass the right variables to it.
# TODO STEP 7: Check out 'cloud_init.sh.tpl' file to know which variables you need.
#resource "aws_instance" "http_server" {
#  ami                  = data.aws_ami.amazon_linux_2_ami.id
#  instance_type        = "t3.small"
#  iam_instance_profile = data.aws_iam_instance_profile.ssm_instance_profile.name
#  user_data = templatefile("${path.module}/cloud_init.sh.tpl", {
#    #variable1 = aws_example.test.endpoint,
#    #variable2 = aws_example.test2.name,
#  })
#
#  tags = {
#    Name = "${var.project}-http-server"
#  }
#}
