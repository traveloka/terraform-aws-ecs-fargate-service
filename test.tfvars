service_name = "test-service"

cluster_role = "fe"

application = "nodejs"

product_domain = "abc"

environment = "staging"

ecs_cluster_arn = "arn:aws:ecs:ap-southeast-1:123456789012:cluster/abc-3c5ef0d4876eed93"

capacity = "5"

target_group_arn = "arn:aws:elasticloadbalancing:ap-southeast-1:123456789012:targetgroup/test-tg/1234567890abcdef"

main_container_name = "app"

container_port = "80"

subnet_ids = ["subnet-00000001", "subnet-00000002", "subnet-00000003"]

security_group_ids = ["sg-00000001"]

assign_public_ip = false

execution_role_arn = "arn:aws:iam::123456789012:role/service-role/ecs-tasks.amazonaws.com/ServiceRoleForEcs-Tasks_test-execution-1b5e77c7a347fc2b"

image_name = "traveloka/test-app"

image_version = "latest"

log_retention = "14"
