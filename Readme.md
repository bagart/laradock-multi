# [LaraDock](https://github.com/laradock/laradock) Multi
Laradock wrapper template for running multiple related projects with different versions of PHP and Node.js such as Microservice Architecture (MSA)

### Demo used 
- [LaraDock](https://laradock.io/) without rewrite original files
- [Laravel](https://laravel.com/) with `PHP 7.4`
- [CoruUi](https://coreui.io/) as `Node.JS` example
- [Microservice Architecture](https://en.wikipedia.org/wiki/Microservices) as concept
- [Docker Compose](https://docs.docker.com/compose/) 

## Instruction for configure step-by-step
- [Integrate](Integrate.md) Demo of usage with Cloud env (`Yandex Cloud` for example as simple and useful) 

### Commands
- `cmd/bash.sh laravel` - connect to `LaraDock-multi` service
- `cmd/logs.sh` - waiting for all logs
- `cmd/logs.sh nginx laravel` - waiting for logs of nginx and `laravel` workers or cli
- `cmd/ps.sh` - shop details about `LaraDock-multi` services
- `cmd/rebuild.sh` - remove, load updates and rebuild each one `LaraDock-multi` services
- `cmd/rebuild.sh laravel-fpm nginx` rebuild only `laravel-fpm` and `nginx`
- `cmd/stop.sh` - stop all services
- `cmd/stop.sh nginx api` - stop services: `nginx` and `api`
- `cmd/up.sh` - start all services
- `cmd/up.sh nginx api` - start services: `nginx` and `api`

## Setup

### Install Docker-CE with Docker-compose
```bash
apt install docker docker-compose
```
### Download Laradock-Multi with laradock
```bash
git clone https://github.com/bagart/laradock-multi.git
cd laradock-multi
```

### Autoconfigure and Auto-deploy
You cal automate Configure, Upgrade and download `Laradock` with command
```bash
cmd/deploy.sh
```

Force Upgrade `Laradock Multi`. It's will remove `laradock` path
```bash
cmd/deploy.sh upgrade
```

### Manual Configure(upgrade) multi-env
```bash
git clone https://github.com/Laradock/laradock.git
cp ./.laradock-multi/. ./laradock/ -r
```

Also, you can use `git submodule add https://github.com/Laradock/laradock.git`

### Install projects

#### PHP Site like Laravel

I will use dummy laravel-like php site for demo
```bash
mkdir projects/laravel
mkdir projects/laravel/public
echo '<?php phpinfo();' >> projects/laravel/public/index.php
```

But you can install original laravel or your exist project
```bash
composer create-project --prefer-dist laravel/laravel projects/laravel
```

#### Node.JS
I will use pretty `CoreUi` admin template on `ReactJS`
```bash
git clone https://github.com/coreui/coreui-free-react-admin-template.git projects/dashboard
cp laradock/nginx/sites/dashboard.conf.example laradock/nginx/sites/dashboard.conf
```
It's already added: `dashboard` docker in [docker-compose.multi.yml](docker-compose.multi.yml).
You can copy this section for using with other node.js projects

## Configure
Feel free to changing [.laradock-multi](.laradock-multi) options

## Using

Using is similar to [https://github.com/bagart/laradock_env](https://github.com/bagart/laradock_env)
```bash
cmd/up.sh
```

### Important note: 
  - Nginx crush in runtime after load config, if some dependency service (php-fpm, node.js) not started. 
    So, immediately `cmd/ps.sh` will return success result and failed in next call
  - laravel service is empty by default
  - dashboard not configured  by default

### HTTP Service
- [dashboard](http://dashboard.localhost/) take a time to building CoreUI
- [dashboard:8081](http://dashboard.localhost:8081/) direct (without `Nginx`)
- [laravel](http://laravel.localhost/)
- [api](http://api.localhost/)

### Alternative
##### docker-compose override
Also you can use `docker-compose.override.yml` [https://docs.docker.com/compose/extends/](https://docs.docker.com/compose/extends/).
But it's depends on platform 
```bash
cd laradock;
cp docker-compose.multi.yml docker-compose.override.yml
```
and remove all typical service like db or `docker-in-docker`
Result:
 - `docker-compose ps` will equal: 
   - `docker-compose ps -f docker-compose.yml -f docker-compose.override.yml`
 - `docker-compose logs` will equal:
   - `docker-compose logs -f docker-compose.yml -f docker-compose.override.yml`

But `docker-compose up` without specs will failed 
   

##### CMD from project

Open [default preoject](projects/default) with IDE

Switch to internal bash terminal

use `Laradock-multi`:
```bash
cmd/up.sh
```

copy this dir to each new project
```bash
cp -r projects/default/cmd projects/laravel/cmd 
```

## Update

```bash
git pull
cd laradock
git pull
cd ..
```
add all changes

- from: `diff .laradock-multi/docker-compose.yml.orig laradock/docker-compose.yml`
  - to `laradock/docker-compose.multiple.yml`
    - `workspace` to `api`, `laravel`, `default`
    - `php-fpm` to `api-fpm`, `laravel-fpm`, `php-fpm`
    - each one with same name

- from: `diff .laradock-multi/env-example.orig laradock/env-example`
  - to `laradick/.env`

Rebuild each `Laradock-Multi` service
```bash
cmd/rebuild.sh
```

## Structure
- [.laradock-multi/](.laradock-multi) - custom services path for `LaraDock`
    - [xdebug.ini](.laradock-multi/xdebug.ini) - custom `xdebug.ini` options fpr `PHP`
    - [.env](.laradock-multi/xdebug.ini) - custom php.ini options
    - [docker-compose.multi.yml](.laradock-multi/docker-compose.multi.yml) - custom docker-compose services
    - [docker-compose.yml.orig](.laradock-multi/docker-compose.yml.orig) - last synced original `docker-compose.yml` (for diff)
    - [env-example.orig](.laradock-multi/env-example.orig) - last synced original `.env` (for diff)
    - [node/](node) - new docker service template with `Node.JS`
    - [nginx/sites/](.laradock-multi/nginx/sites) - path with custm `fcgi` and `proxy` services
        - [api.conf](.laradock-multi/nginx/sites/api.conf) - example with `PHP 5.6`
        - [dashboard.conf](.laradock-multi/nginx/sites/dashboard.conf) - example with `Node.JS` and `CoreUi for React`
        - [laravel.conf](.laradock-multi/nginx/sites/laravel.conf) - example Laravel on `PHP 7.4`
- [cmd/](cmd) - simple command for using with autocomplete
    - [.jump_to_laradock.sh](cmd/.jump_to_laradock.sh) - cd to `LaraDock` path (for internal use)
    - [bash.sh](cmd/bash.sh) - connect to `LaraDock-multi` service
    - [logs.sh](cmd/logs.sh) - `logs -f` all `LaraDock-multi` service or `cmd/logs.sh laravel nginx` for listed
    - [ps.sh](cmd/ps.sh) - show info for `LaraDock-multi` service
    - [rebuild.sh](cmd/rebuild.sh) - remove, pull and rebuild each one LaraDock-multi services or `cmd/rebuild.sh laravel nginx` for listed
    - [stop.sh](cmd/stop.sh) - stop `LaraDock-multi` services or `cmd/stop.sh laravel nginx` for listed
    - [up.sh](cmd/up.sh) - start all `LaraDock-multi` services or `cmd/up.sh laravel nginx` for listed
 - [dumps/](dumps) - path for DB dumps. That will be mount inside DB-service
 - [laradock/](laradock) - original `laradock` + `laradock-multi`
 - [projects/](projects) - custom projects
   - [api/](projects/api) - API project with `PHP 5.6`
   - [dashboard/](projects/dashboard) - CoreUI project with `NodeJS`+`React` (after install)
   - [default/](projects/default) - Default localhost project for internal use or service list
   - [laravel/](projects/laravel) - `Laravel` project  with `PHP 7.4` (after install)
- [Readme.md](Readme.md) - Readme file with instructions
