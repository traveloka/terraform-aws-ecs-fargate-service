locals {
  cluster = "${var.service_name}-${var.cluster_role}"

  global_tags = {
    Service       = "${var.service_name}"
    Cluster       = "${local.cluster}"
    ProductDomain = "${var.product_domain}"
    Environment   = "${var.environment}"
    ManagedBy     = "terraform"
  }

  service_tags = {
    Name = "${module.service_name.name}"
  }

  taskdef_tags = {
    Name = "${module.taskdef_name.name}"
  }
}

module "service_name" {
  source = "github.com/traveloka/terraform-aws-resource-naming?ref=v0.9.0"

  name_prefix = "${local.cluster}"

  //////////////////////////////////////////////////////////////////////////////////
  // WIP: wait for https://github.com/traveloka/terraform-aws-resource-naming/pull/13
  resource_type = "lambda_function"
}

module "taskdef_name" {
  source = "github.com/traveloka/terraform-aws-resource-naming?ref=v0.9.0"

  name_prefix = "${local.cluster}"

  //////////////////////////////////////////////////////////////////////////////////
  // WIP: wait for https://github.com/traveloka/terraform-aws-resource-naming/pull/13
  resource_type = "lambda_function"
}

resource "aws_ecs_service" "app" {
  name          = "${module.service_name.name}"
  cluster       = "${var.ecs_cluster}"
  desired_count = "${var.capacity}"

  launch_type      = "FARGATE"
  platform_version = "${var.platform_version}"

  task_definition = "${aws_ecs_task_definition.app.arn}"

  health_check_grace_period_seconds = "${var.health_check_grace_period_seconds}"

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

  propagate_tags = "SERVICE"
  tags           = "${merge(local.global_tags, local.service_tags, var.service_tags)}"

  lifecycle {
    ignore_changes = [
      "desired_count",
      "task_definition",
    ]
  }
}

resource "aws_ecs_task_definition" "app" {
  family                = "${module.taskdef_name.name}"
  container_definitions = "${data.template_file.container_definition.rendered}"
  task_role_arn         = "${var.task_role}"

  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = "${data.aws_iam_role.execution_role.arn}"
  network_mode             = "awsvpc"

  cpu    = "${var.cpu}"
  memory = "${var.memory}"

  tags = "${merge(local.global_tags, local.taskdef_tags, var.taskdef_tags)}"

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
    environment    = "${jsonencode(var.environment_variables)}"
  }
}

resource "aws_cloudwatch_log_group" "service_log" {
  name              = "${var.log_group_name}"
  retention_in_days = "${var.log_retention}"

  tags = "${merge(local.global_tags, var.log_tags)}"
}
