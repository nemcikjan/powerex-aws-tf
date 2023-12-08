locals {
  s3_trigger_bucket = aws_s3_bucket.powerex_buckets[var.s3_lambda_trigger_bucket_name]
  s3_layer_bucket   = aws_s3_bucket.powerex_buckets[var.s3_lambda_layer_bucket_name]
}

data "aws_iam_policy_document" "allow_access_from_powerex_lambda" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = [
      "s3:GetObject",
    ]

    resources = [
      local.s3_trigger_bucket.arn,
      "${local.s3_trigger_bucket.arn}/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = [module.powerex_lambda.lambda_arn]
    }
  }
}

resource "aws_s3_bucket" "powerex_buckets" {
  for_each = toset([var.s3_lambda_layer_bucket_name, var.s3_lambda_trigger_bucket_name])
  bucket   = each.value
}

resource "aws_s3_bucket_policy" "allow_access_from_powerex_lambda" {
  bucket = local.s3_trigger_bucket.id
  policy = data.aws_iam_policy_document.allow_access_from_powerex_lambda.json
}
