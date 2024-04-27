resource "aws_lambda_function" "this" {
  function_name = var.function_name
  role          = aws_iam_role.iam_for_lambda.arn
  package_type  = "Image"
  image_uri     = "278495751288.dkr.ecr.us-east-1.amazonaws.com/pepe:latest-2"
  description   = var.description
  timeout       = var.timeout_in_seconds
  memory_size   = var.memory_size_in_mb

  lifecycle {
    ignore_changes = [image_uri]
  }
}


resource "aws_lambda_function_url" "test_latest" {
  count = var.create_function_url ? 1 : 0
  function_name      = aws_lambda_function.this.function_name
  authorization_type = "NONE"
}
