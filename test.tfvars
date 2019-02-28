service_name = "test-service"

cluster_name = "test-cluster"

capacity = "5"

target_group = "arn:aws:elasticloadbalancing:ap-southeast-1:123456789012:targetgroup/test-tg/1234567890abcdef"

main_container_name = "app"

service_port = "80"

subnets = ["subnet-00000001", "subnet-00000002", "subnet-00000003"]

security_groups = ["sg-00000001"]

assign_public_ip = false

image_name = "traveloka/test-app:1"

log_retention = "30"

log_group_name = "/ecs/test-app"
