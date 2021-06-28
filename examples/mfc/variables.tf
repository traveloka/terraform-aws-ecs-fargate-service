variable "environment" {
  default = "development"
}

variable "lb_logs_s3_bucket_name" {}

variable "certificate_arn" {}

variable "vpc_id" {}

variable "subnets" {
  type = "list"
}
