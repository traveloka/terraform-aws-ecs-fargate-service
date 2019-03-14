output "service_name" {
  value       = "${aws_ecs_service.app.name}"
  description = "The name of the ECS service"
}

output "service_arn" {
  value       = "${aws_ecs_service.app.id}"
  description = "The ARN of the ECS service"
}

output "taskdef_family" {
  value       = "${aws_ecs_task_definition.app.family}"
  description = "The family name of the task definition"
}

output "taskdef_arn" {
  value       = "${aws_ecs_task_definition.app.arn}"
  description = "The full ARN of the task definition"
}
