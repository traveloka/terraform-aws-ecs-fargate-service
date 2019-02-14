variable "service_name" {
  description = "Name of your service which is also used to identified resources"
  type        = "string"
}

variable "cluster_name" {
  description = "Name of the cluster to which the service belongs"
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

variable "task_definition" {
  description = "IAM role for tasks"
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
