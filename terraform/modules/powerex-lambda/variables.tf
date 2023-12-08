variable "s3_trigger_bucket_name" {
  type = string
}
variable "s3_trigger_bucket_arn" {
  type = string
}

variable "name" {
  type    = string
  default = "powerex-lambda"
}

variable "s3_layer_bucket_name" {
  type    = string
  default = "powerex-layer-bucket"
}

variable "lambda_handler" {
  type = string
}
