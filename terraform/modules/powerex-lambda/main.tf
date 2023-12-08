resource "aws_lambda_layer_version" "powerex_lambda_layer" {
  layer_name          = "${var.name}_layer"
  compatible_runtimes = ["python3.9"]
  s3_bucket           = var.s3_layer_bucket_name
  s3_key              = "${var.name}_layer.zip"
}

resource "aws_lambda_function" "powerex_lambda_function" {
  function_name = var.name
  handler       = var.lambda_handler
  runtime       = "python3.9"
  filename      = "out/${var.name}.zip"
  role          = aws_iam_role.powerex_lambda_role.arn

  layers = [
    aws_lambda_layer_version.powerex_lambda_layer.arn,
  ]
  dead_letter_config {
    target_arn = aws_sqs_queue.powerex_dlq.arn
  }
}

resource "aws_sqs_queue" "powerex_dlq" {
  name                      = "${var.name}-dlq"
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
}
