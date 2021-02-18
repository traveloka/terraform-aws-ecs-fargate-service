locals {
  cluster = "${var.service_name}-${var.cluster_role}"

  global_tags = {
    Service       = "${var.service_name}"
    Cluster       = "${local.cluster}"
    Application   = "${var.application}"
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
  source = "github.com/traveloka/terraform-aws-resource-naming?ref=v0.19.1"

  name_prefix   = "${local.cluster}"
  resource_type = "ecs_service"
}

module "taskdef_name" {
  source = "github.com/traveloka/terraform-aws-resource-naming?ref=v0.19.1"

  name_prefix   = "${local.cluster}"
  resource_type = "ecs_task_definition"
}

module "log_group_name" {
  source = "github.com/traveloka/terraform-aws-resource-naming?ref=v0.19.1"

  name_prefix   = "/tvlk/${var.cluster_role}-${var.application}/${var.service_name}"
  resource_type = "cloudwatch_log_group"
}

resource "aws_ecs_service" "ecs_service" {
  name          = "${module.service_name.name}"
  cluster       = "${var.ecs_cluster_arn}"
  desired_count = "${var.capacity}"

  # Hack, so we can fill it with empty "" to prevent destroying
  # resources with capacity_provider_strategy enabled via web console.
  # capacity_provider_strategy is only available in aws provider > 2.42.0
  launch_type = "${var.launch_type}"

  platform_version                  = "${var.platform_version}"
  task_definition                   = "${aws_ecs_task_definition.task_def.arn}"
  health_check_grace_period_seconds = "${var.health_check_grace_period_seconds}"

  enable_ecs_managed_tags = true

  network_configuration {
    subnets          = "${var.subnet_ids}"
    security_groups  = "${var.security_group_ids}"
    assign_public_ip = "${var.assign_public_ip}"
  }

  load_balancer {
    target_group_arn = "${var.target_group_arn}"
    container_name   = "${var.main_container_name}"
    container_port   = "${var.main_container_port}"
  }

  deployment_controller {
    type = "${var.deployment_controller}"
  }

  propagate_tags = "SERVICE"
  tags           = "${merge(local.global_tags, local.service_tags, var.service_tags)}"

  lifecycle {
    ignore_changes = [
      "desired_count",
      "load_balancer", # https://github.com/hashicorp/terraform-provider-aws/issues/13192
      "platform_version",
      "task_definition",
    ]
  }
}

resource "aws_ecs_task_definition" "task_def" {
  family                = "${module.taskdef_name.name}"
  container_definitions = "${var.container_definitions}"
  task_role_arn         = "${var.task_role_arn}"

  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = "${var.execution_role_arn}"
  network_mode             = "awsvpc"

  cpu    = "${var.cpu}"
  memory = "${var.memory}"

  tags = "${merge(local.global_tags, local.taskdef_tags, var.taskdef_tags)}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_cloudwatch_log_group" "log_group" {
  name              = "${module.log_group_name.name}"
  retention_in_days = "${var.log_retention_in_days}"

  tags = "${merge(local.global_tags, var.log_tags)}"
}
