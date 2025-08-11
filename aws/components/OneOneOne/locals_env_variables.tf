locals {
  environment_variables = concat(var.OneOneOne_environment_variables,[
    {
      name = "PEM111_AMQP_BROKER"
      value = replace(data.aws_mq_broker.OneOneOne_mq_broker.instances[0].endpoints[1],"amqp+ssl","amqps") # https://www.terraform.io/docs/providers/aws/r/mq_broker.html#attributes-reference
    },
    {
      name = "PEM111_AMQP_QUEUE_NAME"
      value = var.pem111_ampq_queue_name
    },
    {
      name = "LOG_LEVEL"
      value = var.OneOneOne_log_level
    },
    {
      name = "PEM111_ITK_ODS_CODE_LIST"
#      value = var.OneOneOne_itk_ods_code_list
      value = ["EM396", "5L399", "RSHSO14A", "NVE06", "FHR04RPX", "E88122", "E88122002", "PS01RPX02"]
    },
    {
      name = "PEM111_ITK_DOS_ID_LIST"
#      value = var.pem111_itk_external_configuration_url
      value = [
        "26428",
        "2000038407",
        "136753",
        "1340268940",
        "2000072936",
        "161145",
        "159744",
        "2000080724"
      ]
    },
    {
      name = "PEM111_ITK_EXTERNAL_CONFIGURATION_URL"
      value = var.pem111_itk_external_configuration_url
    }
  ])
}
