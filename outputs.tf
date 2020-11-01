output "service_name" {
  value       = aws_ecs_service.ecs_service.name
  description = "The name of the ECS service"
}

output "service_arn" {
  value       = aws_ecs_service.ecs_service.id
  description = "The ARN of the ECS service"
}

output "taskdef_family" {
  value       = aws_ecs_task_definition.task_def.family
  description = "The family name of the task definition"
}

output "taskdef_arn" {
  value       = aws_ecs_task_definition.task_def.arn
  description = "The full ARN of the task definition"
}
