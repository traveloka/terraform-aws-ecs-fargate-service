[
    {
        "name": "${container_name}",
        "image": "${image_name}:${version}",
        "essential": true,
        "environment": ${environment},
        "dockerLabels": ${docker_labels},
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "${log_group}",
                "awslogs-region": "${aws_region}",
                "awslogs-stream-prefix": "${version}"
            }
        },
        "secrets": [
        ],
        "portMappings": [
            {
                "protocol": "tcp",
                "containerPort": ${port}
            }
        ],
        "dependsOn": [
        ]
    }
]
