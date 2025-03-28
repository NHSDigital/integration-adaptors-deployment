resource "aws_appautoscaling_target" "service_autoscaling_target" {
  count = local.appautoscaling
  max_capacity = var.maximal_count
  min_capacity = var.minimal_count
  resource_id = "service/${aws_ecs_service.ecs_service.cluster}/${aws_ecs_service.ecs_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace = "ecs"
}