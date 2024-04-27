resource "aws_secretsmanager_secret" "this" {
  name = "function/${var.function_name}"
}

resource "aws_secretsmanager_secret_version" "this" {
  secret_id     = aws_secretsmanager_secret.this.id
  secret_string = jsonencode({})

  lifecycle {
    ignore_changes = [secret_string]
  }
}