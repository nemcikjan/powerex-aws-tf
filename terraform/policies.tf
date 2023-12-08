
data "aws_iam_policy_document" "powerex_lambda_assume_role_policy_doc" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }
  }
}

data "aws_iam_policy_document" "powerex_lambda_s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::*/*"]
  }
}