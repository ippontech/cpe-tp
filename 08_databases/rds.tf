resource "random_password" "password" {
  length    = 10
  special   = false
  min_lower = 10
}

# TODO STEP 3: Complete this code block
#resource "aws_db_subnet_group" "main" {
#  name = "main"
#}

# TODO STEP 4: Complete the following block code to open port 5432 from any IP ("0.0.0.0/0")
#resource "aws_security_group" "postgresql" {
#  name = "${var.project}-postgresql-access"
#}

# TODO STEP 5: Complete the following block code in step 5
#resource "aws_db_instance" "main" {
#  allocated_storage = 10
#  engine            = "postgres"
#  engine_version    = "14"
#  identifier        = "main"
#  instance_class    = "db.t3.small"
#}
