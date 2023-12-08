locals {
  lambda_managed_lambda_basic_policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  #   lambda_managed_lambda_policy_arn       = "arn:aws:iam::aws:policy/service-role/AWSLambdaRole"
}

data "aws_iam_policy_document" "powerex_lambda_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }
  }
}

# data "aws_iam_policy_document" "powerex_eventbridge_assume_role" {
#   statement {
#     actions = ["sts:AssumeRole"]
#     principals {
#       identifiers = ["events.amazonaws.com"]
#       type        = "Service"
#     }
#   }
# }

data "aws_iam_policy_document" "powerex_lambda_policy" {
  statement {
    actions = ["s3:GetObject"]
    resources = [
      var.s3_trigger_bucket_arn,
      "${var.s3_trigger_bucket_arn}/*",
    ]
  }
  statement {
    actions   = ["sqs:SendMessage"]
    resources = [aws_sqs_queue.powerex_dlq.arn]
  }
}

# resource "aws_iam_role" "eventbridge_lambda_invocation" {
#   name               = "eventbridge-lambda-invocation-role"
#   assume_role_policy = data.aws_iam_policy_document.powerex_eventbridge_assume_role.json
# }

# resource "aws_iam_role_policy_attachment" "eventbridge_lambda_invocation_role_attach" {
#   policy_arn = local.lambda_managed_lambda_policy_arn
#   role       = aws_iam_role.eventbridge_lambda_invocation.name
# }

resource "aws_iam_role" "powerex_lambda_role" {
  name = "${var.name}-role"

  assume_role_policy = data.aws_iam_policy_document.powerex_lambda_assume_role.json
}

resource "aws_iam_role_policy" "lambda_s3_policy" {
  role   = aws_iam_role.powerex_lambda_role.id
  policy = data.aws_iam_policy_document.powerex_lambda_policy.json
}

resource "aws_iam_role_policy_attachment" "powerex_lambda_role_attach" {
  policy_arn = local.lambda_managed_lambda_basic_policy_arn
  role       = aws_iam_role.powerex_lambda_role.name
}
