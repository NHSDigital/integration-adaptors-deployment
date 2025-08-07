locals {
  environment_variables = concat(var.OneOneOne_environment_variables,[
    {
      name = "PEM111_AMQP_BROKER"
      value = replace(data.aws_mq_broker.OneOneOne_mq_broker.instances[0].endpoints[1],"amqp+ssl","amqps") # https://www.terraform.io/docs/providers/aws/r/mq_broker.html#attributes-reference
    },
    {
      name = "LOG_LEVEL"
      value = var.OneOneOne_log_level
    }
  ])
}

#locals {
#  secret_variables = [
#    {
#      name      = "PEM111_AMQP_QUEUE_NAME"
#      valueFrom = data.aws_secretsmanager_secret.pem111_queue.arn
#    },
#    {
#      name = "PEM111_ITK_ODS_CODE_LIST"
#      valueFrom = data.aws_secretsmanager_secret.pem111_itk_ods_code_list.arn
#    },
#    {
#      name = "PEM111_ITK_EXTERNAL_CONFIGURATION_URL"
#      valueFrom = data.aws_secretsmanager_secret.pem111_itk_external_configuration_url.arn
#    }
#  ]
#}