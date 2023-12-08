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
  vpc_config {
    subnet_ids         = []
    security_group_ids = []
  }
}
