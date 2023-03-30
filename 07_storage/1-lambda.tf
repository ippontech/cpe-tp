data "archive_file" "move_s3_object_archive_file" {
  type        = "zip"
  source_file = "lambda/move_s3_object.py"
  output_path = "lambda/move_s3_object.zip"
}

data "aws_iam_role" "lab_role" {
  name = "LabRole"
}

resource "aws_lambda_function" "move_s3_object_lambda" {
  function_name    = "${var.project}-move-s3-object"
  role             = data.aws_iam_role.lab_role.arn
  filename         = data.archive_file.move_s3_object_archive_file.output_path
  handler          = "move_s3_object.lambda_handler"
  source_code_hash = data.archive_file.move_s3_object_archive_file.output_base64sha256
  runtime          = "python3.9"

  tags = {
    Name = "${var.project}-move-s3-object"
  }
}
