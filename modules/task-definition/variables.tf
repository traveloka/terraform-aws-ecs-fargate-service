variable "log_group_name" {}

variable "log_retention" {}

variable "environment" {}

variable "container_definition_template" {
  default = ""
}

variable "service_version" {}

variable "service_port" {}

variable "image_name" {}

variable "main_container_name" {}

variable "task_role" {
  default = ""
}

variable "enable_ec2" {}

variable "enable_farget" {}

variable "task_name" {}
