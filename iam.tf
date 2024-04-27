data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "lambda_logging" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["arn:aws:logs:*:*:*"]
  }
}

data "aws_iam_policy_document" "ecr" {
  statement {
    effect    = "Allow"
    actions   = ["ecr:BatchGetImage", "ecr:GetDownloadUrlForLayer"]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "secret_manager" {
  statement {
    effect    = "Allow"
    actions   = ["secretsmanager:GetSecretValue"]
    resources = ["*"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "${var.function_name}-function-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy" "sqs_policy" {
  name   = "LoggingPolicy"
  policy = data.aws_iam_policy_document.lambda_logging.json
  role   = aws_iam_role.iam_for_lambda.id
}

resource "aws_iam_role_policy" "ecr" {
  name   = "ECRPulling"
  policy = data.aws_iam_policy_document.ecr.json
  role   = aws_iam_role.iam_for_lambda.id
}

resource "aws_iam_role_policy" "secret-manager" {
  name   = "SecretManagerPolicy"
  policy = data.aws_iam_policy_document.secret_manager.json
  role   = aws_iam_role.iam_for_lambda.id
}

resource "aws_iam_role_policy_attachment" "AWSLambdaVPCAccessExecutionRole" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}
