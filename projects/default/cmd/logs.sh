#!/bin/bash

cd ../../laradock
  docker-compose -f docker-compose.multi.yml logs -f $1 $2 $3 $4
cd ../projects/default
