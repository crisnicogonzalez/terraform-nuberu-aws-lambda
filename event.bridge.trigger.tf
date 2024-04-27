resource "aws_cloudwatch_event_rule" "eventbridge" {
  count               = lookup(var.triggers, "event_bridge", null) != null ? 1 : 0
  name                = "function_eventbridge_${var.function_name}"
  schedule_expression = var.triggers["event_bridge"]["schedule_expression"]
}

resource "aws_cloudwatch_event_target" "eventbridge_target" {
  count = lookup(var.triggers, "event_bridge", null) != null ? 1 : 0

  rule      = aws_cloudwatch_event_rule.eventbridge[0].name
  target_id = "Lambda"
  arn       = aws_lambda_function.this.arn
}

resource "aws_lambda_permission" "eventbridge_permission" {
  count = lookup(var.triggers, "event_bridge", null) != null ? 1 : 0

  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = var.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.eventbridge[0].arn
}

