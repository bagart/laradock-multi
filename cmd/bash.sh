#!/bin/bash
COMMAND='bash'

CUR_PATH="$(pwd)"

if [[ -f "$(dirname "${BASH_SOURCE[0]}")/../.env" ]]; then
    . "$(dirname "${BASH_SOURCE[0]}")/../.env"
else
    . "$(dirname "${BASH_SOURCE[0]}")/../.env.prod"
fi

. "$(dirname "${BASH_SOURCE[0]}")/.jump_to_laradock.sh";
SERVICE=$1
LOGIN=''

if  [[ $2 != '' ]]; then
    LOGIN="--user=$2"
fi

if [[ "$SERVICE" == "" ]]; then
  SERVICE=$LARADOCK_SERVICE_DEFAULT
fi

docker-compose -f docker-compose.multi.yml up -d $SERVICE;
docker-compose -f docker-compose.multi.yml exec $LOGIN $SERVICE $COMMAND;

cd "${CUR_PATH}";
