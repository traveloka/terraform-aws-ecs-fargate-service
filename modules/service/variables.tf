variable "service_name" {
  description = "Name of your service which is also used to identified resources"
  type        = "string"
}

variable "environment" {
  description = "Environment name (production, staging, testing, etc.)"
  type        = "string"
}

variable "product_domain" {
  description = "Product domain name for tagging"
  type        = "string"
}

variable "cluster_name" {
  description = "Name of the cluster to which the service belongs"
  type        = "string"
}

variable "image_name" {
  description = "Name of container image which your tasks will run in the service"
  type        = "string"
}

variable "service_version" {
  description = "Version of container image which your tasks will run in the service"
  type        = "string"
}

variable "target_group" {
  description = "ALB target group that associated with this service"
  type        = "string"
}

variable "main_container_name" {
  description = "Name of the container name that will be registered to target group"
  type        = "string"
  default     = "app"
}

variable "container_definition_template" {
  description = "Path to container definition template file. "
  type        = "string"
  default     = ""
}

variable "task_role" {
  description = "IAM role for tasks"
  type        = "string"
  default     = ""
}

variable "subnets" {
  description = "A list of subnet IDs to attach to the ALB"
  type        = "list"
}

variable "vpc_id" {
  description = "The identifier of the VPC in which to create the target group"
  type        = "string"
}

variable "service_port" {
  description = "Port on which the container app run"
  type        = "string"
  default     = 80
}

variable "capacity" {
  description = "Number of task that will run in this service"
  type        = "string"
  default     = 2
}

variable "log_group_name" {
  description = "AWS CloudWatch Log Group for storing task log"
  type        = "string"
}

variable "log_retention" {
  description = "number of days to retain log events in cloudwatch"
  type        = "string"
  default     = 14
}
