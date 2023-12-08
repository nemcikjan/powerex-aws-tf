output "lambda_arn" {
  value = aws_lambda_function.powerex_lambda_function.arn
}

output "lambda_layer_arn" {
  value = aws_lambda_layer_version.powerex_lambda_layer.arn
}
