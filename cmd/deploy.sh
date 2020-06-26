#!/bin/bash

CUR_PATH="$(pwd)"

if [[ -f "$(dirname "${BASH_SOURCE[0]}")/../.env" ]]; then
    . "$(dirname "${BASH_SOURCE[0]}")/../.env"
else
    . "$(dirname "${BASH_SOURCE[0]}")/../.env.prod"
fi

if [[ $1 == 'root' ]]; then
  if [[ ! $LARADOCK_DEV_VERSION && $LARADOCK_DEV_VERSION != 'false' ]]; then
    ssh-agent sh -c "ssh-add .keys/$(basename $(pwd)); git fetch --all;git reset --hard origin/master";
  fi
  exit
fi

if [[ $1 == 'projects' ]]; then
  # @todo projects/*/cmd/deploy.sh
  exit
fi

if [[ $1 == 'quick' ]]; then
  echo Deploy: quick
  cmd/stop.sh
  "${BASH_SOURCE[0]}" root
  "${BASH_SOURCE[0]}" laradock
  cmd/up.sh
  exit
fi;

if [[ $1 == 'laradock' ]]; then
  . "$(dirname "${BASH_SOURCE[0]}")/.jump_to_laradock.sh";
    cp ../.laradock-multi/. ./ -r
  cd "${CUR_PATH}";
  exit
fi

if [[ $1 == 'reset' ]]; then
    echo Deploy: Laradoc-multi reset laradock
  . "$(dirname "${BASH_SOURCE[0]}")/.jump_to_laradock.sh";
    git reset --hard master
    cp ../.laradock-multi/. ./ -r
    docker-compose -f docker-compose.multi.yml build > /dev/null
  cd "${CUR_PATH}";
  exit;
fi;

if [[ $1 == 'upgrade' || ! -d ./laradock ]]; then
  "${BASH_SOURCE[0]}" root
  cd "$(dirname "${BASH_SOURCE[0]}")/..";
  rm -rf ./laradock_new
  git clone https://github.com/Laradock/laradock.git ./laradock_new
  cp ./.laradock-multi/. ./laradock_new/ -r

  cd ./laradock_new/
    docker-compose -f docker-compose.multi.yml build --pull > /dev/null
  cd ..

  if [[ -d ./laradock ]]; then
    cmd/stop.sh
    if [[ $LARADOCK_BACKUP != "" ]]; then
      mkdir -p "$LARADOCK_BACKUP/$(basename $(pwd))"
      rm -rf "$LARADOCK_BACKUP/$(basename $(pwd))"/laradock
      mv laradock "$LARADOCK_BACKUP/$(basename $(pwd))"/laradock
    else
      rm -rf ./laradock
    fi
  fi
  mv laradock_new laradock
  "${BASH_SOURCE[0]}" projects
else
  cmd/stop.sh
  "${BASH_SOURCE[0]}" root
  "${BASH_SOURCE[0]}" reset
  "${BASH_SOURCE[0]}" projects
fi

cmd/cert.sh
cmd/up.sh
cd "${CUR_PATH}";
