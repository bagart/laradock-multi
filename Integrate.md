# Integration
Let's make dev env for project "`docker-multi`" with cloud public env.

I will use `Yandex Cloud`

## Prepare private project repository
#### STEP 0: preparing local work machine:

##### For: Mac/Windows
- Download and install [GIT](https://git-scm.com/downloads)

##### ANY OS
- (optional) Generate SSH KEY on your local machine if not exist 
```bash
ssh-keygen
```
- for **"SSH PUBLIC key"** use only string content from `~/.ssh/id_rsa.pub`. 
    It's saved on your local user home dir(`/home/user` or `C:\Users\user`) after `ssh-keygen`

#### STEP 1: Prepare repository 
- auth to [github.com](https://github.com)
- if needed: add your SSH public keys `cat ~/.ssh/id_rsa.pub` 
    to [https://github.com/settings/keys](https://github.com/settings/keys) 
- visit page [github.com/bagart/laradock-multi](https://github.com/bagart/laradock-multi)
- (optional) press **[ ⭐ Star ]** ^_^ and close
- press **[ ⑂ Fork ]** button and make fork.
    Private fork repository is allowed.

    You can use it:
    - as DOCKER-PROJECT.

        Next step is:
        - Fork as `docker-multi` +/- private

    - as TEMPLATE.

        Is useful for:
        - many independent projects
        - upgrade with manual merge.
        - prepare Merge Requst to original `laradock-multi`
        
        Next step is:
        - Fork as is +/- private
        - create new repository `docker-multi` at [github.com/new](https://github.com/new)
            with your template from preview branch +/- private

So, we have working repository `docker-multi` (+/- private) for configure it to projects

```bash
export docker-multi-git=
```
#### STEP 2 (optional): re-configure server 

##### Optional: `local dev env`
You can use local computer with any OS: `Mac`, `Windows`, `Linux`
- Download and install [DOCKER CE (Comuniti Edition)](https://hub.docker.com/)

Details for platform optimization
 at official [docker.com](https://docker.com/) 
 and [Lardock.io](https://laradock.io/) page.

#### Optional: `Yandex Cloud`
I will use `Yandex Cloud` with `Ubuntu 18+` for public access.

Price: **~ $5 - $10 per month** (2020-02-15),

- auth to [console.cloud.yandex.ru](https://console.cloud.yandex.ru/)
- create "folder" with name `docker-multi`
- click to **[ Create resource ]** and choose **[ Virtual machine instance ]**
- fill with:
  - Name: `docker-multi`
  - Public images: `Ubuntu 18+`
  - Computing resources: minimal. You can add resource in the feature on demand
  - Disk type: ssd ;) 
  - Disk size: 10gb+. Note: you can add space, but not reduce.
    `Laradock Multi` minimal installation from this instruction require `6.5gb`. 
    
    `~8gb` after:
       - multiple docker rebuild  
       - without connect external projects (without Laravel and NodeJs)
       - not clear apt cache and docker snapshots
    
  - RAM 3gb or 4gb if you will use big size DB and in-memory queue/cache. 
  - Additional: `Preemptible`. It's most important for minimize price for dev env
  - Access - Service account: create `Yandex-cloud` work account with `admin` role
  - Access - Login: add account with custom! name. 
    Your local name is useful. 
    I will use `bagart` and call them for ssh connect in next steps
  - Access - SSH key:
    - (optional) Generate it with `ssh-keygen` on local machine 
    - Copy content of `~/.ssh/id_rsa.pub` (PUBLIC key) from your local User-home dir
- push **[ Create ]** buton
- visit [console.cloud.yandex.ru](https://console.cloud.yandex.ru/)
- click to **[ Cloud computer ]**

Now you can see your 
- wait for status: `Running` for your `docker-multi` _VM_ (Virtual Machine).
- click to  `docker-multi` _VM_.
- copy your unique `Public IPv4`.
- (optional) click to edit button near `Public IPv4` -> [ ... ] -> [ make static ]
    It's take a money! and need to connect without check actual IP and use domain/https  
- set local variable name $DOCKER_multi_IP with `docker-multi` _VM_ IP
```bash
export DOCKER_multi_IP=84.201.0X0.0X0; echo DOCKER_multi_IP is: $DOCKER_multi_IP;ping $DOCKER_multi_IP -n 3
```

- check valid answer like:
        DOCKER_multi_IP is: 84.201.0X0.0X0
        
        Pinging 84.201.0X0.0X0 with 32 bytes of data:
        Reply from 84.201.0X0.0X0: bytes=32 time=3ms TTL=53
        Reply from 84.201.0X0.0X0: bytes=32 time=3ms TTL=53
        Reply from 84.201.0X0.0X0: bytes=32 time=3ms TTL=53
        
        Ping statistics for 84.201.0X0.0X0:
            Packets: Sent = 1, Received = 1, Lost = 0 (0% loss),
        Approximate round trip times in milli-seconds:
            Minimum = 3ms, Maximum = 3ms, Average = 3ms

- connect to `docker-multi` _VM_ over ssh. use login for creating VM steps.
 If your login equals your local login, use 
 ```bash
 ssh $DOCKER_multi_IP
 ```
If you use custom login: my login is `bagart`
```bash
ssh bagart@$DOCKER_multi_IP
```

#### Optional: Prepare `Ubuntu 18+`
Use it for new machine

- prepare basic utils
```bash
sudo apt update
sudo apt full-upgrade -y
sudo apt install -y git htop
```

Note:  `htop` is tool for resource monitoring in real time.

Also you can install `mc`, `php`, `composer`, etc.

- install and configure docker
```bash
sudo apt install -y docker-compose
sudo groupadd docker
sudo usermod -aG docker $USER
sudo systemctl enable docker
sudo /etc/init.d/docker start
```

- Now you must logout/login from console. Better is reboot OS after apt upgrade
```bash
sudo reboot
```
- reconnect with last command `ssh $DOCKER_multi_IP`. repeat if OS not booted
- check docker status (it's must auto-started): 
```bash
/etc/init.d/docker status
```
#### STEP 3: download `Laradock-Multi`

- go to your work dir. for example 
```bash
sudo mkdir /app
sudo chown $USER /app
cd /app
```

Also you can use `/var/www` or `~` (home dir)
- for NOT LOCAL env (`Yandex Cloud`, etc) with private `docker-multi` repo,
 you can prepare deploy keys (passphrase is recommended). Please, always use your personal account, not root
```bash
mkdir .keys
ssh-keygen -f .keys/docker-multi
#check prermissions
ls -la .keys
echo ssh public deploy key for docker-multi is:
cat .keys/docker-multi.pub
```

- go to your `docker-multi` repository [github.com/bagart/laradock-multi](https://github.com/bagart/laradock-multi)
- click **[ * Settings ] ->  [ Deploy keys ] -> [ Add deploy key ]**
- fill with
    - name: yandex-cloud-docker-multi
    - Key: `copy your ssh public deploy key for docker-multi` (content of `.keys/docker-multi.pub`)
    - Allow write access: you can use it temporary to prepare work configuration
- click **[ Clone or download ]** 
- copy your git-link
  - SSH URL is preferred for: private repo, local dev env, `Yandex Cloud` with deploy(read only) keys
    
    example: `git@github.com:bagart/laradock-multi.git`

  - HTTPS URL is preferred for open access for read only or git remote for push with deploy keys
    
    example: `https://github.com/bagart/laradock-multi.git`
  
  It's for clone/pull/push? by deploy keys. Or you need to generate a new ssh keys inside `docker-multi` _VM_ 

- run in you dev env: any OS or `Yandex Cloud`. 

**IMPORTANT**: use your `dashboard-multi` git link from **STEP 1**

```bash
git clone YOUR-GIT-LINK docker-multi
```
Example with local ssh key 
```bash
git clone git@github.com:bagart/laradock-multi.git docker-multi
```

Example with https access (public repo or github login+password)
```bash
git clone https://github.com/bagart/laradock-multi.git docker-multi
```

For private repo with deploy ssh key (`Yandex-cloud`, etc)
```bash
ssh-agent sh -c "ssh-add .keys/docker-multi; git clone YOUR-GIT-LINK docker-multi"
```

example:
```bash
ssh-agent sh -c "ssh-add .keys/docker-multi; git clone git@github.com:bagart/laradock-multi.git docker-multi"
``` 

- move .keys inside your `docker-multi`. 
```bash
mv .keys docker-multi
``` 
Now we have:

    |- /app                             # optional root
        |- docker-multi                    # laradock-multi form for customize your project
            |- .keys                    # laradock-multi form for customize your project
            |   |- docker-multi            # deploy private key for docker-multi
            |   |- docker-multi.pub        # deploy public key for docker-multi
            |- ...                      # original laradock-multi


#### STEP 4: configure basic `Laradock-Multi`
It's similar to original instructions [https://github.com/bagart/laradock-multi](https://github.com/bagart/laradock-multi)
```bash
cmd/deploy.sh
```
It's similar to: 
```bash
git clone https://github.com/Laradock/laradock.git
cp ./.laradock-multi/. ./laradock/ -r
rm ./laradock/docker-compose.yml.orig
rm ./laradock/env-example.orig
```

- (optional) install Laravel or NodeJs service from [https://github.com/bagart/laradock-multi](https://github.com/bagart/laradock-multi) instruction 

#### STEP 5: RUN
- running default `laradock Multi` env
```bash
cmd/up.sh
```
It's take a time, space, traffic and other resource

#### STEP 6: self check
- check `Laradock Multi`
```bash
cmd/ps.sh
```
with result similar to:

    bagart@docker-multi:/app/docker-multi$ cmd/ps.sh
               Name                          Command                State                          Ports
    --------------------------------------------------------------------------------------------------------------------------
    laradock_api-fpm_1            docker-php-entrypoint php-fpm    Up         9000/tcp, 9001/tcp
    laradock_dashboard_1          docker-entrypoint.sh bash  ...   Exit 254
    laradock_docker-in-docker_1   dockerd-entrypoint.sh            Up         2375/tcp, 2376/tcp
    laradock_laravel-fpm_1        docker-php-entrypoint php-fpm    Up         9000/tcp, 9001/tcp
    laradock_laravel_1            /sbin/my_init                    Up
    laradock_nginx_1              /bin/bash /opt/startup.sh        Up         0.0.0.0:443->443/tcp, 0.0.0.0:80->80/tcp, 81/tcp
    laradock_php-fpm_1            docker-php-entrypoint php-fpm    Up         9000/tcp, 9001/tcp

if not, try to run again
```bash
cmd/up.sh
```
 
- check disk

```bash
df
df -i
```
With result for 7gb disk
    
    Filesystem     1K-blocks    Used Available Use% Mounted on
    ...
    tmpfs             300700    7748    292952   3% /run
    /dev/vda2        8192420 7205976    611788  93% /
    ...
    Filesystem     Inodes  IUsed  IFree IUse% Mounted on
    ...
    /dev/vda2      512000 349912 162088   69% /
    ...
 
So, used disk size is `6.2gb`  

- check site inside `Yandex Cloud` or local dev env
```bash
curl http://localhost
```
Expect:

    <h1>Default project </h1>
    with php: 7.4.1
    ...

- check browser for cloud env (`Yandex Cloud`)

```bash
curl "http://$DOCKER_multi_IP"
```
Expect same result

- check multi-domains inside `Yandex Cloud` or local dev env
```bash
curl http://api.localhost
```
Expect:

    <h1>API demo</h1>

```bash
curl http://unknown.localhost
```
Expect:

    <h1>Default project </h1>


#### STEP 7: (optional) configure DNS ot /etc/hosts 
- for localhost you can use
```bash
curl http://default.localhost
```
- for configure custom domains you can edit `/etc/hosts`
 
- for public service (`Yandex Cloud`) with https
    - get domain.
        
        You can get free 3rd level domains from other sites
    
        I will use [bagrt.com](bagrt.com) for `$8.49 per year` from [internetbs.net](https://internetbs.net)
    
        For example: `.eu` domain just for `$3.59 first year`.
    
    - configure domain: use your public static IP for $DOCKER_multi_IP

            A	@	3600	$DOCKER_multi_IP
            A	*	3600	$DOCKER_multi_IP
            
- configure nginx
  - open in editor `laradock/nginx/sites/**custom**.conf` local, in terminal `nano laradock/nginx/sites/**custom**.conf` or mount with sftp, sshfs
  - change `server_name ~^api\.(multi\.|localhost$);` multi to your project name

- check domain (It's can take a time)

```bash
curl unknown.multi.bagrt.com
```
and open in browser: [http://unknown.multi.bagrt.com](http://unknown.multi.bagrt.com)

Expect:
    
    <h1>Default project </h1>
    
```bash
curl api.multi.bagrt.com
```
open in browser: [http://api.multi.bagrt.com](http://api.multi.bagrt.com)
Expect:
    
    <h1>Api demo</h1>

#### STEP 8: Add your custom repository
Follow [https://github.com/bagart/laradock-multi](https://github.com/bagart/laradock-multi) instruction 

There examples with `Laravel` and `CoreUI`/`Node.js` examples

#### STEP 9: Configure HTTPS  

#### STEP 10: push env changes to `docker-multi` repo
For use `cmd/deploy.sh` script you must save all customization to `.laradock-multi` dir

Or write your deploy tool for upgrade `Laradock Multi` or make it manual. 

```
cp laradock/.env .laradock-multi/
#cp laradock/ ###### .laradock-multi/ #####

git add .laradock-multi
git commit -m 'from server'
ssh-agent sh -c "ssh-add .keys/$(basename $(pwd)); git push";
```

#### Important note:
Please  use `cmd/deploy.sh` script carefully for protect your customization in `laradock` path.
Upgrade option will remove your laradock dir!
