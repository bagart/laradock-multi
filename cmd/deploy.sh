#!/bin/bash

ssh-agent sh -c "ssh-add .keys/$(basename $(pwd)); git pull";
if [[ $1 == 'upgrade' || ! -d ./laradock ]]; then
  rm -rf ./laradock_new
  git clone https://github.com/Laradock/laradock.git ./laradock_new
  cp ./.laradock-multi/. ./laradock_new/ -r
  cd ./laradock_new/
    docker-compose -f docker-compose.multi.yml build --pull
  cd ../
  rm -rf laradock_old
  mkdir -p ~/backup/"$(basename $(pwd))"
  rm -rf ~/backup/"$(basename $(pwd))"/laradock

  if [[  -d ./laradock ]]; then
    mv laradock ~/backup/"$(basename $(pwd))"/laradock
  fi

  mv laradock_new laradock
else
  cmd/stop.sh
  cp ./.laradock-multi/. ./laradock/ -r
fi

cmd/up.sh
