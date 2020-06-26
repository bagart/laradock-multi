#!/bin/bash
LARADOCK_NGINX_CONTAINER=
LARADOCK_NGINX_SERVICE_RUNNED=
CUR_PATH="$(pwd)"

echo "Laradock-multi try to get https certificate"

if [[ "$LARADOCK_NGINX_CONTAINER" == "" ]]; then
  . "$(dirname "${BASH_SOURCE[0]}")/.jump_to_laradock.sh";
    LARADOCK_NGINX_CONTAINER="$(docker-compose -f docker-compose.multi.yml ps -q nginx)"
  cd "${CUR_PATH}";
fi;

if [ "$(docker inspect -f '{{.State.Running}}' ${LARADOCK_NGINX_CONTAINER} 2>/dev/null)" = "true" ]; then
  LARADOCK_NGINX_SERVICE_RUNNED=1
else
  LARADOCK_NGINX_SERVICE_RUNNED=0
fi

if [ "$LARADOCK_NGINX_SERVICE_RUNNED" = 0 ]; then
  echo "try to start nginx with default configuration"
  . "$(dirname "${BASH_SOURCE[0]}")/.jump_to_laradock.sh";
    rm nginx/sites/*.conf
    git checkout nginx/sites
    docker-compose -f docker-compose.multi.yml up -d nginx
  cd "${CUR_PATH}";
fi

. "$(dirname "${BASH_SOURCE[0]}")/.jump_to_laradock.sh";
  docker-compose -f docker-compose.multi.yml up certbot-multi

cd "${CUR_PATH}";

if [ "$LARADOCK_NGINX_SERVICE_RUNNED" = 0 ]; then
  cmd/stop.sh nginx
  cmd/deploy.sh reset
fi
