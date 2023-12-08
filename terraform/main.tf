provider "aws" {
  region = var.aws_region
  assume_role {
    role_arn = var.aws_role_arn
  }
}

module "powerex_lambda" {
  source = "./modules/powerex-lambda"

  lambda_handler         = var.lambda_handler
  s3_trigger_bucket_name = local.s3_trigger_bucket.id
  s3_trigger_bucket_arn  = local.s3_trigger_bucket.arn
  s3_layer_bucket_name   = local.s3_layer_bucket.id
  name                   = var.lambda_name
  depends_on             = [aws_s3_object.powerex_deps_layer]
}

resource "aws_s3_object" "powerex_deps_layer" {
  bucket = local.s3_layer_bucket.id
  key    = "${var.lambda_name}_layer.zip"
  source = "out/${var.lambda_name}-deps.zip"
}
