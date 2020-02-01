#!/bin/bash
CUR_PATH="$(pwd)"
. "$(dirname "${BASH_SOURCE[0]}")/.jump_to_laradock.sh";

  docker-compose -f docker-compose.multi.yml logs -f $1 $2 $3 $4 $5;

cd "${CUR_PATH}";

