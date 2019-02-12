[
  {
    "name": "${container_name}",
    "image": "${image_name}:${version}",
    "essential": true,
    "environment": [
      { "name": "PORT", "value": "${port}" }
    ],
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
