output "name" {
  value = "${aws_ecs_service.app.name}"
}

output "arn" {
  value = "${aws_ecs_service.app.id}"
}
