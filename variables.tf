variable "service_name" {
  description = "Name of the ECS service. Note: this value will be also used to name resources"
  type        = string
}

variable "cluster_role" {
  description = "The role of the cluster in the service"
  type        = string
  default     = "app"
}

variable "application" {
  description = "Application type that the ECS task will serve"
  type        = string
}

variable "product_domain" {
  description = "The product domain that this service belongs to"
  type        = string
}

variable "environment" {
  description = "Environment where the service run"
  type        = string
}

variable "ecs_cluster_arn" {
  description = "ARN of the ECS cluster to launch service in"
  type        = string
}

variable "platform_version" {
  description = "Version of the Fargate platform to run the service on"
  type        = string
  default     = "LATEST"
}

variable "capacity" {
  description = "Number of tasks to run in the service"
  type        = string
  default     = 2
}

variable "target_group_arn" {
  description = "ARN of the ALB target group to associate with the service"
  type        = string
}

variable "image_name" {
  description = "Name of the docker image that will be used by the task"
  type        = string
}

variable "image_version" {
  description = "Version/tag of the docker image to be used by the task"
  type        = string
}

variable "use_latest_task_definition" {
  description = "Wether to always use latest task definition. Set it to false if you have external release tool"
  type        = bool
  default     = true
}

variable "main_container_name" {
  description = "Name of the container name that will be registered to target group"
  type        = string
  default     = "app"
}

variable "main_container_port" {
  description = "Port for main container to listen for incoming connections"
  type        = string
  default     = 80
}

variable "health_check_grace_period_seconds" {
  description = "Seconds to ignore failing load balancer health checks on newly instantiated tasks to prevent premature shutdown."
  type        = string
  default     = 0
}

variable "subnet_ids" {
  description = "List of IDs of subnets to launch the service in"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of IDs of security groups to associate with the service"
  type        = list(string)
}

variable "assign_public_ip" {
  description = "Whether or not to assign public IP address to the task ENI"
  type        = string
  default     = false
}

variable "log_retention_in_days" {
  description = "Number of days to retain service logs"
  type        = string
  default     = 14
}

variable "container_definition_template_file" {
  description = "Custom container definition template"
  type        = string
  default     = ""
}

variable "task_role_arn" {
  description = "ARN of IAM role to be used by the task"
  type        = string
  default     = ""
}

variable "execution_role_arn" {
  description = "ARN of IAM role to be used by container agent to pull container images, write logs, access ECS secrets and parameter store"
  type        = string
}

variable "environment_variables" {
  description = "List of environment variables to pass to the task"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "cpu" {
  description = "Number of cpu units to allocate for one task"
  type        = number
  default     = 1024
}

variable "memory" {
  description = "Amount of memory (in MiB) to allocate for one task"
  type        = number
  default     = "1024"
}

variable "service_tags" {
  description = "Custom tags for ECS Service"
  type        = map(string)
  default     = {}
}

variable "taskdef_tags" {
  description = "Custom tags for ECS Task Definition"
  type        = map(string)
  default     = {}
}

variable "log_tags" {
  description = "Custom tags for CloudWatch Log Group"
  type        = map(string)
  default     = {}
}

variable "capacity_provider_strategies" {
  description = "The capacity provider strategy to use for the service."
  type = list(object({
    capacity_provider = string
    weight            = number
    base              = number
  }))
  default = []
}
