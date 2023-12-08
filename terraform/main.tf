provider "aws" {
  region = var.aws_region
  assume_role {
    role_arn = var.aws_role_arn
  }
}

resource "aws_s3_bucket" "powerex_bucket" {
  for_each = toset([var.s3_lambda_layer_bucket_name, var.s3_lambda_trigger_bucket_name])
  bucket   = each.value
}

# Create an IAM Role for Lambda function
resource "aws_iam_role" "powerex_lambda_role" {
  name = "powerex-lambda-role"

  assume_role_policy = data.aws_iam_policy_document.powerex_lambda_assume_role_policy_doc.json
  inline_policy {
    name   = "s3-policy"
    policy = data.aws_iam_policy_document.powerex_lambda_s3_policy
  }
}

# Attach policies to Lambda role
resource "aws_iam_role_policy_attachment" "powerex_lambda_role_attach" {
  policy_arn = "arn:aws:iam::aws:policy/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.powerex_lambda_role.name
}
