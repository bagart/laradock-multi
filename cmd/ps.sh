#!/bin/bash
CUR_PATH="$(pwd)"
. "$(dirname "${BASH_SOURCE[0]}")/.jump_to_laradock.sh";

  docker-compose -f docker-compose.multi.yml ps;

cd "${CUR_PATH}";
