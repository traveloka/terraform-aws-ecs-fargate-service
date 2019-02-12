resource "aws_ecs_service" "app" {
  name            = "${var.service_name}"
  cluster         = "${data.aws_ecs_cluster.main.arn}"
  task_definition = "${var.task_definition}"
  desired_count   = "${var.capacity}"
  iam_role        = "${data.aws_iam_role.ecs_service_role.arn}"

  launch_type      = "FARGATE"
  platform_version = "${var.platform_version}"

  network_configuration {
    subnets          = "${var.subnets}"
    security_groups  = "${var.security_groups}"
    assign_public_ip = "${var.assign_public_ip}"
  }

  load_balancer {
    target_group_arn = "${var.target_group}"
    container_name   = "${var.main_container_name}"
    container_port   = "${var.service_port}"
  }

  lifecycle {
    ignore_changes = ["desired_count"]
  }
}
