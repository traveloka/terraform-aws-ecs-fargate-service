resource "aws_ecs_service" "app" {
  name          = "${var.service_name}"
  cluster       = "${data.aws_ecs_cluster.main.arn}"
  desired_count = "${var.capacity}"

  launch_type      = "FARGATE"
  platform_version = "${var.platform_version}"

  task_definition = "${aws_ecs_task_definition.app.arn}"

  network_configuration {
    subnets          = ["${var.subnets}"]
    security_groups  = ["${var.security_groups}"]
    assign_public_ip = "${var.assign_public_ip}"
  }

  load_balancer {
    target_group_arn = "${var.target_group}"
    container_name   = "${var.main_container_name}"
    container_port   = "${var.service_port}"
  }

  lifecycle {
    ignore_changes = [
      "desired_count",
      "task_definition",
    ]
  }
}

resource "aws_ecs_task_definition" "app" {
  family                = "${var.service_name}"
  container_definitions = "${data.template_file.container_definition.rendered}"
  task_role_arn         = "${var.task_role}"

  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = "${data.aws_iam_role.execution_role.arn}"
  network_mode             = "awsvpc"

  cpu    = "${var.cpu}"
  memory = "${var.memory}"

  lifecycle {
    create_before_destroy = true
  }
}

data "template_file" "container_definition" {
  template = "${var.container_definition_template != "" ? var.container_definition_template : file("${path.module}/templates/container-definition.json.tpl")}"

  vars {
    aws_region     = "${data.aws_region.current.name}"
    container_name = "${var.main_container_name}"
    image_name     = "${var.image_name}"
    version        = "${var.service_version}"
    port           = "${var.service_port}"
    log_group      = "${aws_cloudwatch_log_group.service_log.name}"
    environment    = "${jsonencode(var.environment)}"
  }
}

resource "aws_cloudwatch_log_group" "service_log" {
  name              = "${var.log_group_name}"
  retention_in_days = "${var.log_retention}"
}
