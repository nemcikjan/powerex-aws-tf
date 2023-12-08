# resource "aws_cloudwatch_event_target" "powerex_lambda_target" {
#   arn  = aws_lambda_function.powerex_lambda_function.arn
#   rule = aws_cloudwatch_event_rule.s3_powerex_object_added_event.id
#   dead_letter_config {
#     arn = aws_sqs_queue.powerex_dlq.arn
#   }
#   role_arn = aws_iam_role.eventbridge_lambda_invocation.arn
# }

# resource "aws_cloudwatch_event_rule" "s3_powerex_object_added_event" {
#   name = "s3-powerex-object-added"
#   event_pattern = jsonencode(
#     {
#       "source" : ["aws.s3"],
#       "detail-type" : ["Object Created"],
#       "detail" : {
#         "bucket" : {
#           "name" : [var.s3_trigger_bucket_name]
#         }
#       }
#     }
#   )
# }

# resource "aws_sqs_queue" "powerex_dlq" {
#   name                      = "${var.name}-dlq"
#   max_message_size          = 2048
#   message_retention_seconds = 86400
#   receive_wait_time_seconds = 10
# }
