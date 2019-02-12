variable "service_name" {
  description = "Name of your service which is also used to identified resources"
  type        = "string"
}

variable "cluster_name" {
  description = "Name of the cluster to which the service belongs"
  type        = "string"
}

variable "task_definition" {
  description = "The family and revision (family:revision ) or full ARN of the task definition to run in your service"
  type        = "string"
}

variable "platform_version" {
  description = "The family and revision (family:revision ) or full ARN of the task definition to run in your service"
  type        = "string"
  default     = "LATEST"
}

variable "capacity" {
  description = "Number of task that will run in this service"
  type        = "string"
  default     = 2
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

variable "service_port" {
  description = "Port on which the container app run"
  type        = "string"
  default     = 80
}

variable "subnets" {
  description = "The subnets associated with the service"
  type        = "list"
}

variable "security_groups" {
  description = "The security groups associated with the service"
  type        = "list"
}

variable "assign_public_ip" {
  description = "Assign a public IP address to the ENI"
  type        = "string"
  default     = "false"
}
