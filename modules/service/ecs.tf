data "aws_ecs_cluster" "main" {
  cluster_name = "${var.cluster_name}"
}

resource "aws_ecs_service" "app" {
  name            = "${var.service_name}"
  cluster         = "${data.aws_ecs_cluster.main.arn}"
  task_definition = "${aws_ecs_task_definition.app.arn}"
  desired_count   = "${var.capacity}"
  iam_role        = "${module.service_role.role_arn}"

  placement_strategy {
    type  = "spread"
    field = "attribute:ecs.availability-zone"
  }

  load_balancer {
    target_group_arn = "${var.target_group}"
    container_name   = "${var.main_container_name}"
    container_port   = "${var.service_port}"
  }

  lifecycle {
    ignore_changes = ["desired_count"]
  }

  depends_on = [
    "aws_iam_role_policy_attachment.ecs_service", # wait for ecs service role to have necessary access
  ]
}

module "service_role" {
  source = "github.com/traveloka/terraform-aws-iam-role//modules/service?ref=v0.4.1"

  aws_service      = "ecs.amazonaws.com"
  role_identifier  = "${var.service_name}"
  role_description = "Service Role for ${var.service_name}"
}

resource "aws_iam_role_policy_attachment" "ecs_service" {
  role       = "${module.service_role.role_arn}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}
