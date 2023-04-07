#!/usr/bin/env bash

set -x

sudo yum update -y
sudo yum install -y docker
sudo systemctl start docker.service
sudo systemctl enable docker.service

docker container run \
  -e SPRING_DATASOURCE_URL=jdbc:postgresql://${rds_endpoint}/${database_name} \
  -e SPRING_DATASOURCE_USERNAME=${database_username} \
  -e SPRING_DATASOURCE_PASSWORD=${database_password} \
  -e _JAVA_OPTIONS="-Xmx512m -Xms256m" \
  -e SPRING_PROFILES_ACTIVE="prod,api-docs" \
  -p 80:8080 \
  hufon/cpe:latest
