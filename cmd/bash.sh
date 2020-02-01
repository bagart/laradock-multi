#!/bin/bash
CUR_PATH="$(pwd)"
. "$(dirname "${BASH_SOURCE[0]}")/.jump_to_laradock.sh";

  docker-compose -f docker-compose.multi.yml up -d $1;
  docker-compose -f docker-compose.multi.yml exec $1 bash;

cd "${CUR_PATH}";


