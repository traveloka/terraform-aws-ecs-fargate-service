[
  {
    "name": "${container_name}",
    "image": "${image_name}",
    "essential": true,
    "environment": ${environment},
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${log_group}",
        "awslogs-region": "${aws_region}",
        "awslogs-stream-prefix": "${version}"
      }
    },
    "portMappings": [
      {
        "protocol": "tcp",
        "containerPort": ${port}
      }
    ]
  }
]
