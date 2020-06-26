#!/bin/bash
CUR_PATH="$(pwd)"
. "$(dirname "${BASH_SOURCE[0]}")/.jump_to_laradock.sh";

  #docker-compose -f docker-compose.multi.yml up -d $1;
  docker-compose -f docker-compose.multi.yml exec $1 sh -c "$2 $3 $4 $5 $6 $7 $8 $9"

cd "${CUR_PATH}";


