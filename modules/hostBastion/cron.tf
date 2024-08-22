resource "random_string" "key" {
  length  = 5
  special = false
}

module "aws_lambda_function" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "7.7.1"

    function_name          = "${random_string.key.result}-lambda1"
  description            = "My awesome lambda function"
  handler                = "index.lambda_handler"
  runtime                = "python3.12"
  ephemeral_storage_size = 10240
  architectures          = ["x86_64"]
  publish                = true

  source_path = "${path.module}/cronFunction/index.py"

  environment_variables = {
    INSTANCE_ID = module.hostBastion.id
  }

}

//Start host bastion 8am
resource "aws_cloudwatch_event_rule" "start_host_bastion" {
  name                = "start-host-bastion"
  description         = "Encender el host bastion a las 8 am"
  schedule_expression = "cron(0 8 * * ? *)"
}

resource "aws_cloudwatch_event_target" "start_host_bastion_target" {
  rule = aws_cloudwatch_event_rule.start_host_bastion.name
  arn  = module.aws_lambda_function.lambda_function_arn
}

resource "aws_lambda_permission" "allow_eventbridge_start" {
  statement_id  = "AllowExecutionFromCloudWatchStart"
  action        = "lambda:InvokeFunction"
  function_name = module.aws_lambda_function.lambda_function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.start_host_bastion.arn
}

//Stop host bastion 5pm
resource "aws_cloudwatch_event_rule" "stop_host_bastion" {
  name                = "stop-host-bastion"
  description         = "Apagar el host bastion a las 5 pm"
  schedule_expression = "cron(0 17 * * ? *)"
}

resource "aws_cloudwatch_event_target" "stop_host_bastion_target" {
  rule = aws_cloudwatch_event_rule.stop_host_bastion.name
  arn  = module.aws_lambda_function.lambda_function_arn
}

resource "aws_lambda_permission" "allow_eventbridge_stop" {
  statement_id  = "AllowExecutionFromCloudWatchStop"
  action        = "lambda:InvokeFunction"
  function_name = module.aws_lambda_function.lambda_function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.stop_host_bastion.arn
}
