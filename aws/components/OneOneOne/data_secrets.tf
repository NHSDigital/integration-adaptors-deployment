data "aws_secretsmanager_secret" "mq_username" {
  name = "amazon-mq-nia-broker-username"
}

data "aws_secretsmanager_secret" "mq_password" {
  name = "amazon-mq-nia-broker-password"
}

data "aws_secretsmanager_secret" "pem111_queue" {
  name = "PEM111_AMQP_QUEUE_NAME"
}

data "aws_secretsmanager_secret" "pem111_itk_ods_code_list" {
  name = "PEM111_ITK_ODS_CODE_LIST"
}

data "aws_secretsmanager_secret" "pem111_itk_external_configuration_url" {
  name = "PEM111_ITK_EXTERNAL_CONFIGURATION_URL"
}


# nginx secrets

data "aws_secretsmanager_secret" "nginx_server_certificate" {
  name = "nginx-111-server-public"
}

data "aws_secretsmanager_secret" "nginx_server_certificate_key" {
  name = "nginx-111-server-private"
}

data "aws_secretsmanager_secret" "nginx_ca_certificate" {
  name = "nginx-111-ca-cer"
}

data "aws_secretsmanager_secret" "nginx_client_certificate" {
  name = "nginx-111-client-public"
}
