#!/bin/bash
CUR_PATH="$(pwd)"
. "$(dirname "${BASH_SOURCE[0]}")/.jump_to_laradock.sh";

  docker-compose -f docker-compose.multi.yml stop -f $1 $2 $3 $4 $5;
  docker-compose -f docker-compose.multi.yml down -f $1 $2 $3 $4 $5;
  docker-compose -f docker-compose.multi.yml rm   -f $1 $2 $3 $4 $5;
  docker-compose -f docker-compose.multi.yml build --pull $1 $2 $3 $4 $5;

cd "${CUR_PATH}";
