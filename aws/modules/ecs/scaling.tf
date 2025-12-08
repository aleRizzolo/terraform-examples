locals {
  ecs_services = {
    main_service   = aws_ecs_service.main_service.name
    celery_service = aws_ecs_service.celery_service.name
  }
}

resource "aws_appautoscaling_target" "ecs_scaling" {
  for_each           = local.ecs_services
  max_capacity       = var.autoscaling_max_capacity
  min_capacity       = var.autoscaling_min_capacity
  resource_id        = "service/${aws_ecs_cluster.ecs_cluster.name}/${each.value}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

# Scale UP policy
resource "aws_appautoscaling_policy" "ecs_scale_up" {
  for_each           = aws_appautoscaling_target.ecs_scaling
  name               = "scale-up-${each.key}"
  policy_type        = "StepScaling"
  resource_id        = each.value.resource_id
  scalable_dimension = each.value.scalable_dimension
  service_namespace  = each.value.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }
}

# Scale DOWN policy
resource "aws_appautoscaling_policy" "ecs_scale_down" {
  for_each           = aws_appautoscaling_target.ecs_scaling
  name               = "scale-down-${each.key}"
  policy_type        = "StepScaling"
  resource_id        = each.value.resource_id
  scalable_dimension = each.value.scalable_dimension
  service_namespace  = each.value.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 300
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }
}

# cloudWatch alarm for HIGH CPU (scale up at 70%)
resource "aws_cloudwatch_metric_alarm" "ecs_cpu_high" {
  for_each            = local.ecs_services
  alarm_name          = "${each.key}-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 70
  alarm_description   = "Triggers when CPU exceeds 70%"
  alarm_actions       = [aws_appautoscaling_policy.ecs_scale_up[each.key].arn]

  dimensions = {
    ClusterName = aws_ecs_cluster.ecs_cluster.name
    ServiceName = each.value
  }
}

# cloudWatch alarm for LOW CPU (scale down at 30%)
resource "aws_cloudwatch_metric_alarm" "ecs_cpu_low" {
  for_each            = local.ecs_services
  alarm_name          = "${each.key}-cpu-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 3
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 300
  statistic           = "Average"
  threshold           = 30
  alarm_description   = "Triggers when CPU falls below 30%"
  alarm_actions       = [aws_appautoscaling_policy.ecs_scale_down[each.key].arn]

  dimensions = {
    ClusterName = aws_ecs_cluster.ecs_cluster.name
    ServiceName = each.value
  }
}