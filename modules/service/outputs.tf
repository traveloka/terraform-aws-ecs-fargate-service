output "name" {
  value = "${aws_ecs_service.app.name}"
}

output "arn" {
  value = "${aws_ecs_service.app.id}"
}

output "task_definition" {
  value = "${aws_ecs_task_definition.app.arn}"
}

output "log_group" {
  value = "${aws_cloudwatch_log_group.service_log.name}"
}

output "log_group_arn" {
  value = "${aws_cloudwatch_log_group.service_log.arn}"
}

output "service_version" {
  value = "${var.service_version}"
}
