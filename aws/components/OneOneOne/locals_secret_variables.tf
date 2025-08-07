locals {
    secret_variables = [
    {
      name = "PEM111_AMQP_USERNAME"
      valueFrom = data.aws_secretsmanager_secret.mq_username.arn
    },
    {
      name = "PEM111_AMQP_PASSWORD"
      valueFrom = data.aws_secretsmanager_secret.mq_password.arn
    },
      {
        name      = "PEM111_AMQP_QUEUE_NAME"
        valueFrom = data.aws_secretsmanager_secret.pem111_queue.arn
      },
      {
        name = "PEM111_ITK_ODS_CODE_LIST"
        valueFrom = data.aws_secretsmanager_secret.pem111_itk_ods_code_list.arn
      },
  ]
}
