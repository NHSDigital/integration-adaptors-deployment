variable "gpc-consumer_service_desired_count" {
  type = number
  description = "Number of containers to run in the service"
}

variable "gpc-consumer_service_minimal_count" {
  type = number
  description = "Minimal number of containers to run in the service"
}

variable "gpc-consumer_service_maximal_count" {
  type = number
  description = "Maximal number of containers to run in the service"
}

variable "gpc-consumer_service_container_port" {
  type = number
  description = "Port Number on which service within container will be listening"
}

variable "gpc-consumer_service_application_port" {
  type = number
  description = "Port number on which the service load balancer will listen"
  default = 8080
}

variable "gpc-consumer_service_launch_type" {
  type = string
  description = "Type of cluster on which this service will be run, FARGATE or EC2"
}

variable "gpc-consumer_build_id" {
  type = string
  description = "Number of the current build, used for tagging the logs"
  default = "main-124-e1a5b55"
}

variable "gpc-consumer_environment_variables" {
  type = list(object({name=string, value=string}))
  description = "List of objects for Environment variables"
  default = []
}

variable "gpc-consumer_root_log_level" {
  type = string
  description = "Level of logging for entire application including third-party dependencies"
  default = "WARN"
}

variable "gpc-consumer_log_level" {
  type = string
  description = "Level of logging for GPC-CONSUMER application"
  default = "INFO"
}

variable "gpc-consumer_supplier_ods_code" {
  type = string
  description = "GPC Supplier ODS code"
  default = ""
}

variable "gpc-consumer_healthcheck_path" {
  type = string
  description = "Path on which the container provides info about its status"
  default = "/healthcheck"
}

variable "gpc-consumer_service_target_request_count" {
  type = number
  description = "The target number of requests per minute that an service should handle. The number of services will be autoscaled so each instance handles this number of requests. This value should be tuned based on the results of performance testing."
  default = 1200
}

variable "gpc-consumer_logs_datetime_format" {
  type = string
  description = "Format for date and time in AWS cloudwatch logs"
  default = "%Y-%m-%d %H:%M:%S%L"
}

variable "gpc-consumer_create_wiremock" {
  type = bool
  default = false
  description = "Should an wiremock mock be created and used by GPC-CONSUMER"
}

variable "gpc-consumer_wiremock_container_port" {
  type = number
  default = 8080
}

variable "gpc-consumer_wiremock_application_port" {
  type = number
  default = 8080
}

variable "gpc-consumer_sds_url" {
  type = string
  description = "URL to the SDS API"
  default = 8080 
}

variable "gpc-consumer_ssp_url" {
  type = string
  description = "FQDN for the spine secure proxy"
  default = ""
}

variable "gpc-consumer_include_certs" {
  type = bool
  description = "If TRUE, GPCC Spine Certs & Key Secrets will be included in envrionment variables"
  default = false
}

# secret names
# Define the names of secrets in secret manager for secret variables used by gpc-consumer
# These are different depending on the way MHS is connected to NHS systems

variable secret_name_spine_client_cert {
  type = string
  default = ""
}

variable secret_name_spine_client_key {
  type = string
  default = ""
}

variable secret_name_spine_root_ca_cert {
  type = string
  default = ""
}

variable secret_name_spine_sub_ca_cert {
  type = string
  default = ""
}

variable secret_name_sds_apikey {
  type = string
  default = ""
}
