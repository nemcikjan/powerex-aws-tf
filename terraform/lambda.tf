data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/../file-metadata/function.py"
  output_path = "out/powerex-lambda.zip"
}

data "archive_file" "deps_layer" {
  type        = "zip"
  output_path = "out/deps-lambda-layer.zip"
  source_dir  = "${path.module}/../package"
}

resource "aws_s3_object" "deps_layer" {
  bucket = var.s3_lambda_layer_bucket_name
  key    = "deps_layer.zip"
  source = "out/deps-lambda-layer.zip"

  etag = filemd5("out/deps-lambda-layer.zip")
}

resource "aws_lambda_function" "powerex_lambda_function" {
  function_name = var.lambda_function_name
  handler       = "function.lambda_handler"
  runtime       = "python3.9"
  filename      = "out/powerex-lambda.zip"
  role          = aws_iam_role.powerex_lambda_role.arn

  layers = [
    aws_lambda_layer_version.powerex_lambda_layer.arn,
  ]
}

resource "null_resource" "build_layer" {
  provisioner "local-exec" {
    command = "10-build-layer.sh"
    working_dir = "${path.module}/../scripts"
  }
}


resource "aws_lambda_layer_version" "powerex_lambda_layer" {
  layer_name          = "powerex_lambda_layer"
  compatible_runtimes = ["python3.9"]
  s3_bucket           = aws_s3_bucket.powerex_bucket[var.s3_lambda_layer_bucket_name].bucket_domain_name
  s3_key              = aws_s3_object.deps_layer.id
  depends_on = [ null_resource.build_layer ]
}
