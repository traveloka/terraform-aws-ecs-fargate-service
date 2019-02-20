data "aws_region" "current" {}

data "aws_ecs_cluster" "main" {
  cluster_name = "${var.cluster_name}"
}

data "aws_iam_role" "execution_role" {
  name = "${var.execution_role_name}"
}
