#!/bin/bash
CUR_PATH="$(pwd)"
if [[ -f "$(dirname "${BASH_SOURCE[0]}")/../.env" ]]; then
  . "$(dirname "${BASH_SOURCE[0]}")/../.env"
else
  . "$(dirname "${BASH_SOURCE[0]}")/../.env.prod"
fi

if [[ "$1" != "" ]]; then
  LARADOCK_SERVICES=$1
fi

if [[ "$LARADOCK_SERVICES" == "" ]]; then
  LARADOCK_SERVICES='nginx'
fi

echo "Run laradock services: $LARADOCK_SERVICES"

. "$(dirname "${BASH_SOURCE[0]}")/.jump_to_laradock.sh";
  docker-compose -f docker-compose.multi.yml up -d $LARADOCK_SERVICES;
  docker-compose -f docker-compose.multi.yml ps
cd "${CUR_PATH}";
