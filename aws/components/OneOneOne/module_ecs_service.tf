module "OneOneOne_ecs_service" {
  source = "../../modules/module_ecs_service"

  project         = var.project
  component       = var.component
  environment     = var.environment
  region          = var.region
  module_instance = "OneOneOne_ecs"
  default_tags    = local.default_tags
  
  availability_zones = local.availability_zones

  image_name        = local.image_name
  cluster_id        = data.terraform_remote_state.base.outputs.base_cluster_id
  minimal_count     = var.OneOneOne_service_minimal_count
  desired_count     = var.OneOneOne_service_desired_count
  maximal_count     = var.OneOneOne_service_maximal_count
  service_target_request_count = var.OneOneOne_service_target_request_count

  container_port    = var.OneOneOne_use_nginx_proxy ? var.OneOneOne_nginx_container_port : var.OneOneOne_service_container_port
  application_port  = var.OneOneOne_use_nginx_proxy ? var.OneOneOne_nginx_application_port : var.OneOneOne_service_application_port
  launch_type       = var.OneOneOne_service_launch_type
  log_stream_prefix = var.OneOneOne_build_id
  healthcheck_path  = var.OneOneOne_use_nginx_proxy ?  var.OneOneOne_nginx_healthcheck_path : var.OneOneOne_healthcheck_path
  enable_load_balancing = true
  use_application_lb = var.OneOneOne_use_nginx_proxy ? false : true
  load_balancer_type = var.OneOneOne_use_nginx_proxy ? "network" : "application"
  protocol = var.OneOneOne_use_nginx_proxy ? "TCP" : "HTTP"

  container_healthcheck_port = var.OneOneOne_use_nginx_proxy ? var.OneOneOne_nginx_healthcheck_port :  var.OneOneOne_service_container_port
  enable_dlt                 = var.enable_dlt
  dlt_vpc_id                 = var.dlt_vpc_id

  environment_variables = local.environment_variables
  secret_variables      = local.secret_variables

  task_execution_role_arn = aws_iam_role.ecs_service_task_execution_role.arn
  task_role_arn           = data.aws_iam_role.ecs_service_task_role.arn
  
  additional_security_groups = [
    data.terraform_remote_state.base.outputs.core_sg_id,
    data.terraform_remote_state.base.outputs.docdb_access_sg_id
  ]

  lb_allowed_security_groups = [
    data.terraform_remote_state.account.outputs.jumpbox_sg_id
  ]

  additional_container_config = var.OneOneOne_use_nginx_proxy ? local.nginx_container_config : []

  create_testbox=var.create_testbox
  jumpbox_sg_id = data.terraform_remote_state.account.outputs.jumpbox_sg_id
  vpc_id = data.terraform_remote_state.base.outputs.vpc_id
  lb_subnet_ids = data.terraform_remote_state.base.outputs.ptl_connected ? data.terraform_remote_state.base.outputs.ptl_lb_subnet_ids : aws_subnet.service_subnet.*.id
  container_subnet_ids= data.terraform_remote_state.base.outputs.ptl_connected ? data.terraform_remote_state.base.outputs.ptl_container_subnet_ids : aws_subnet.service_subnet.*.id
}
