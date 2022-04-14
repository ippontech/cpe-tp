data "aws_ami" "amazon_linux_2_ami" {
  most_recent = true
  name_regex  = "^amzn2-ami-hvm-[\\d.]+-x86_64-gp2$"
  owners      = ["amazon"]
}

data "aws_iam_instance_profile" "ssm_instance_profile" {
  name = "LabInstanceProfile"
}

# TODO STEP 6: Complete the following block code to open HTTP port 80 from any IP ("0.0.0.0/0")
# TODO and also open all TCP ports towards any IP
#resource "aws_security_group" "http" {
#  name        = "${var.project}-http-access"
#  description = "HTTP"
#  vpc_id      = module.vpc.vpc_id
#}

# TODO STEP 7: Choose a subnet for your instance, add a Security Group to it and complete the user data
# TODO to pass the right variables to it. Check out 'cloud_init.sh.tpl' file to know which variables you need.
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
