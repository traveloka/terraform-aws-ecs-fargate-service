provider "aws" {
  region = "ap-southeast-1"
}

locals {
  service_name   = "mfccols"
  cluster_role   = "mfcbe"
  product_domain = "mfc"

  ecs_cluster_name = "mfcecs"

  image_name = "015110552125.dkr.ecr.ap-southeast-1.amazonaws.com/mfccols-app"

  container_port = 5000

  cpu    = 256
  memory = 512

  tg_deregistration_delay = 90

  autoscaling_target_rpm = 3000 # = 50 req/s
  autoscaling_target_cpu = 75   # %
}

module "service" {
  source = "../.."

  service_name   = "${local.service_name}"
  cluster_role   = "${local.cluster_role}"
  application    = "mfccols"
  product_domain = "mfc"
  environment    = "${var.environment}"

  ecs_cluster_arn = "${local.ecs_cluster_name}"

  capacity      = 3
  image_name    = "${local.image_name}"
  image_version = "latest"

  main_container_port = "${local.container_port}"

  execution_role_arn = "arn:aws:iam::123456789012:role/service-role/ecs-tasks.amazonaws.com/ServiceRoleForEcs-Tasks_webdemo-execution-1b5e77c7a347fc2b"

  cpu    = "${local.cpu}"
  memory = "${local.memory}"

  target_group_arn = "${module.lb.tg_arn}"

  subnet_ids         = "${var.subnets}"
  security_group_ids = ["${aws_security_group.app.id}"]
  assign_public_ip   = false
}

module "lb" {
  source = "github.com/traveloka/terraform-aws-alb-single-listener?ref=v0.2.2"

  service_name   = "${local.service_name}"
  cluster_role   = "${local.cluster_role}"
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
  tg_port        = "${local.container_port}"

  tg_deregistration_delay = "${local.tg_deregistration_delay}"

  tg_stickiness = {
    type    = "lb_cookie"
    enabled = false
  }

  tg_health_check {
    port = "${local.container_port}"
  }
}

resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = 4
  min_capacity       = 1
  resource_id        = "service/${local.ecs_cluster_name}/${module.service.service_name}"
  role_arn           = "arn:aws:iam::1234567890ab:role/aws-service-role/ecs.application-autoscaling.amazonaws.com/AWSServiceRoleForApplicationAutoScaling_ECSService"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "request" {
  name               = "${local.service_name}-request"
  resource_id        = "${aws_appautoscaling_target.ecs_target.resource_id}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  policy_type = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    target_value = "${local.autoscaling_target_rpm}"

    predefined_metric_specification {
      predefined_metric_type = "ALBRequestCountPerTarget"
      resource_label         = "${module.lb.lb_arn_suffix}/${module.lb.tg_arn_suffix}"
    }
  }
}

resource "aws_appautoscaling_policy" "cpu" {
  name               = "${local.service_name}-cpu"
  resource_id        = "${aws_appautoscaling_target.ecs_target.resource_id}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  policy_type = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    target_value = "${local.autoscaling_target_cpu}"

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
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
  from_port                = "${local.container_port}"
  to_port                  = "${local.container_port}"
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
  from_port                = "${local.container_port}"
  to_port                  = "${local.container_port}"
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "ingress_lb_from_office" {
  type              = "ingress"
  security_group_id = "${aws_security_group.lb.id}"
  cidr_blocks       = ["10.0.0.0/8"]
  from_port         = "443"
  to_port           = "443"
  protocol          = "tcp"
}
