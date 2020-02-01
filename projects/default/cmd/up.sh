#!/bin/bash

cd ../../laradock
  docker-compose -f docker-compose.milti.yml up -d dashboard && \
  docker-compose -f docker-compose.milti.yml up -d laravel && \
  docker-compose -f docker-compose.milti.yml up -d nginx;
cd ../projects/default

. cmd/ps.sh
