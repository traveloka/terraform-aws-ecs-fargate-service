variable "service_name" {
  description = "Name of your service which is also used to identified resources"
  type        = "string"
}

variable "cluster_role" {
  description = "The role of the cluster in the service"
  type        = "string"
}

variable "product_domain" {
  description = "The product domain that this service belongs to"
  type        = "string"
}

variable "environment" {
  description = "Environment where the service run"
  type        = "string"
  default     = "development"
}

variable "ecs_cluster" {
  description = "Name of the cluster to which the ECS service belongs"
  type        = "string"
}

variable "platform_version" {
  description = "The platform version on which to run your service."
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

variable "image_name" {
  description = "The name of docker image that will be used by this service"
  type        = "string"
}

variable "service_version" {
  description = "The tag of the docker version to run"
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

variable "health_check_grace_period_seconds" {
  description = "Seconds to ignore failing load balancer health checks on newly instantiated tasks to prevent premature shutdown."
  type        = "string"
  default     = 0
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
  default     = false
}

variable "log_group_name" {
  description = "CloudWatch log group name where the service log place"
  type        = "string"
}

variable "log_retention" {
  description = "The number of day the logs will be keept"
  type        = "string"
  default     = 30
}

variable "container_definition_template" {
  description = "Custom container definition template"
  type        = "string"
  default     = ""
}

variable "task_role" {
  description = "The ARN of IAM role that allows your Amazon ECS container task to make calls to other AWS services."
  type        = "string"
  default     = ""
}

variable "execution_role_name" {
  description = "The name of the execution role that will be used by fargate to run tasks"
  type        = "string"
  default     = "ecsTaskExecutionRole"
}

variable "environment_variables" {
  description = "Environment variables for the task"
  type        = "list"
  default     = []
}

variable "cpu" {
  description = "The number of cpu units used by the task."
  type        = "string"
  default     = "1024"
}

variable "memory" {
  description = "The amount (in MiB) of memory used by the task."
  type        = "string"
  default     = "1024"
}

variable "service_tags" {
  description = "Custom tags for ECS Service"
  type        = "map"
  default     = {}
}

variable "taskdef_tags" {
  description = "Custom tags for ECS Task Definition"
  type        = "map"
  default     = {}
}

variable "log_tags" {
  description = "Custom tags for CloudWatch Log Group"
  type        = "map"
  default     = {}
}
