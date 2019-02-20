provider "aws" {
  region = "ap-southeast-1"
}

locals {
  service_name   = "webdemo"
  cluster_name   = "webecs"
  product_domain = "web"

  image_name = "1234567890ab.dkr.ecr.ap-southeast-1.amazonaws.com/webdemo"

  service_port = 3000

  cpu    = 256
  memory = 512

  log_group = "/ecs/${local.service_name}"

  tg_deregistration_delay = 90
}

module "service" {
  source = "../../modules/fargate"

  service_name = "${local.service_name}"
  cluster_name = "${local.cluster_name}"
  target_group = "${module.lb.tg_arn}"

  image_name      = "${local.image_name}"
  service_version = "latest"
  service_port    = "${local.service_port}"

  cpu    = "${local.cpu}"
  memory = "${local.memory}"

  subnets         = "${var.subnets}"
  security_groups = ["${aws_security_group.app.id}"]
  log_group_name  = "${local.log_group}"
}

module "lb" {
  source = "github.com/terraform/terraform-aws-alb-single-listener?ref=cd66ca512ba34692920e25b037d5934851a7f36f"

  service_name   = "${local.service_name}"
  cluster_role   = "app"
  environment    = "${var.environment}"
  product_domain = "${local.product_domain}"
  description    = "Load balancer for ${local.service_name}"

  lb_logs_s3_bucket_name = "${var.lb_logs_s3_bucket_name}"

  vpc_id             = "${var.vpc_id}"
  lb_subnet_ids      = "${var.subnets}"
  lb_security_groups = ["${aws_security_group.lb.id}"]

  listener_ssl_policy      = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
  listener_certificate_arn = "${var.certificate_arn}"

  tg_target_type = "ip"
  tg_port        = "${local.service_port}"

  tg_deregistration_delay = "${local.tg_deregistration_delay}"

  tg_stickiness = {
    type    = "lb_cookie"
    enabled = false
  }

  tg_health_check {
    port = "${local.service_port}"
  }
}

resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = 4
  min_capacity       = 1
  resource_id        = "service/${var.cluster_name}/${var.service_name}"
  role_arn           = "-----------------------"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_policy" {
  name               = "scale-down"
  policy_type        = "TargetTrackingScaling"
  resource_id        = "service/clusterName/serviceName"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  target_tracking_scaling_policy_configuration {
    target_value = ""
  }
}

resource "aws_security_group" "lb" {
  name   = "${local.service_name}-lbint"
  vpc_id = "${var.vpc_id}"
}

resource "aws_security_group" "app" {
  name   = "${local.service_name}-app"
  vpc_id = "${var.vpc_id}"
}

resource "aws_security_group_rule" "ingress_app_from_lb" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.app.id}"
  source_security_group_id = "${aws_security_group.lb.id}"
  from_port                = "${local.service_port}"
  to_port                  = "${local.service_port}"
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "egress_app_to_internet" {
  type              = "egress"
  security_group_id = "${aws_security_group.app.id}"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = "0"
  to_port           = "65535"
  protocol          = "tcp"
}

resource "aws_security_group_rule" "egress_app_from_lb" {
  type                     = "egress"
  security_group_id        = "${aws_security_group.lb.id}"
  source_security_group_id = "${aws_security_group.app.id}"
  from_port                = "${local.service_port}"
  to_port                  = "${local.service_port}"
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "ingress_lb_from_office" {
  type              = "ingress"
  security_group_id = "${aws_security_group.lb.id}"
  cidr_blocks       = ["10.0.0.0/8", "192.168.0.0/16"]
  from_port         = "443"
  to_port           = "443"
  protocol          = "tcp"
}
