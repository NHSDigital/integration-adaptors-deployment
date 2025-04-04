module "mhs_inbound_ecs_service" {
  source = "../../modules/module_ecs_service"

  project         = var.project
  component       = var.component
  environment     = var.environment
  region          = var.region
  module_instance = "mhs_in_ecs"
  default_tags    = local.default_tags
  
  availability_zones = local.availability_zones

  image_name        = local.inbound_image_name
  cluster_id        = data.terraform_remote_state.base.outputs.base_cluster_id
  minimal_count     = var.mhs_service_minimal_count
  desired_count     = var.mhs_service_desired_count
  maximal_count     = var.mhs_service_maximal_count
  service_target_request_count = var.mhs_service_target_request_count

  container_port    = var.mhs_inbound_service_container_port
  application_port  = var.mhs_inbound_service_container_port
  launch_type       = var.mhs_service_launch_type
  log_stream_prefix = local.inbound_logs_prefix
  healthcheck_path  = var.mhs_healthcheck_path
  enable_load_balancing = true
  use_application_lb = false 
  load_balancer_type = "network"
  protocol =  "TCP"
  logs_datetime_format = var.logs_datetime_format

  container_healthcheck_port = var.mhs_inbound_service_healthcheck_port
  enable_dlt                 = var.enable_dlt
  dlt_vpc_id                 = var.dlt_vpc_id

  environment_variables = local.inbound_variables
  secret_variables      = local.inbound_secret_variables

  task_execution_role_arn = aws_iam_role.ecs_service_task_execution_role.arn
  task_role_arn           = data.aws_iam_role.ecs_service_task_role.arn
  
  additional_security_groups = [
    data.terraform_remote_state.base.outputs.core_sg_id,
    data.terraform_remote_state.base.outputs.docdb_access_sg_id
  ]

  lb_allowed_security_groups = [
    data.terraform_remote_state.account.outputs.jumpbox_sg_id,
  ]

  lb_allowed_cidrs = var.ptl_connected ? var.ptl_allowed_incoming_cidrs : []
  container_allowed_cidrs = var.ptl_connected ? var.ptl_allowed_incoming_cidrs : []

  # For network type LBs the LB Security Group does not matter and is transparent
  # Traffic has to be resricted on the Target Load Balancer

  container_allowed_security_groups = [
    data.terraform_remote_state.account.outputs.jumpbox_sg_id,
  ]

  additional_container_config =  []

  private_ips_for_lb = var.ptl_connected ? [ var.mhs_inbound_lb_ip ] : []

  create_testbox=var.create_testbox
  jumpbox_sg_id = data.terraform_remote_state.account.outputs.jumpbox_sg_id
  vpc_id = data.terraform_remote_state.base.outputs.vpc_id
  lb_subnet_ids = data.terraform_remote_state.base.outputs.ptl_connected ? data.terraform_remote_state.base.outputs.ptl_lb_subnet_ids : aws_subnet.service_subnet.*.id
  container_subnet_ids= data.terraform_remote_state.base.outputs.ptl_connected ? data.terraform_remote_state.base.outputs.ptl_container_subnet_ids : aws_subnet.service_subnet.*.id
}
