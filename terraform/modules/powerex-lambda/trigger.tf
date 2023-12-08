resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.powerex_lambda_assume_role.json
}

resource "aws_lambda_permission" "allow_bucket" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.powerex_lambda_function.arn
  principal     = "s3.amazonaws.com"
  source_arn    = var.s3_trigger_bucket_arn
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = var.s3_trigger_bucket_name

  lambda_function {
    lambda_function_arn = aws_lambda_function.powerex_lambda_function.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_bucket]
}
