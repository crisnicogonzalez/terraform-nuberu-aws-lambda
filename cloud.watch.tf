resource "aws_cloudwatch_log_group" "example" {
  name              = var.function_name
  retention_in_days = 3
}