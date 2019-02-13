data "aws_region" "current" {}

resource "aws_ecs_task_definition" "app" {
  family                = "${var.task_name}"
  container_definitions = "${data.template_file.container_definition.rendered}"
  task_role_arn         = "${var.task_role}"

  requires_compatibilities = "${list(var.enable_ec2 ? "EC2" : "", var.enable_farget ? "FARGATE" : "")}"

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
    environment    = "${var.environment}"
  }
}

resource "aws_cloudwatch_log_group" "service_log" {
  name              = "${var.log_group_name}"
  retention_in_days = "${var.log_retention}"
}
