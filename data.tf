data "aws_region" "current" {}

data "aws_iam_role" "execution_role" {
  name = "${var.execution_role_name}"
}
