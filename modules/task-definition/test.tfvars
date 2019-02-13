task_name = "test-app"

environment = "test"

enable_ec2 = false

enable_farget = true

image_name = "traveloka/test-app"

main_container_name = "app"

log_group_name = "/ecs/test-app"

log_retention = "30"

service_version = "dummy"

service_port = "80"
