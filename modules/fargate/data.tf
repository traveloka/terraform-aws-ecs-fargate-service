data "aws_region" "current" {}

data "aws_ecs_cluster" "main" {
  cluster_name = "${var.cluster_name}"
}

data "aws_iam_role" "ecs_service_role" {
  name = "AWSServiceRoleForECS"
}
