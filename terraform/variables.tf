variable "aws_region" {
  default = "eu-central-1"
  type    = string
}

variable "aws_role_arn" {
  default   = ""
  sensitive = true
  type      = string
}

variable "s3_lambda_layer_bucket_name" {
  default = ""
  type    = string
}

variable "s3_lambda_trigger_bucket_name" {
  default = ""
  type    = string
}

variable "lambda_name" {
  default = "powerex-lambda"
  type    = string
}

variable "lambda_handler" {
  type = string
}
