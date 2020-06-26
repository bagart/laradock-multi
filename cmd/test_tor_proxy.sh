#!/bin/bash
echo Telegram:
curl -sx socks5://torproxy:9050 https://api.telegram.org/

UA='Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.61 Safari/537.36'

echo 'whatismyipaddress.com:'
echo . . . . . No proxy . . . . . . . . . . . . . .
curl https://whatismyipaddress.com/
echo
echo . . . . . . direct . . . . . . . . . . . . . . .
curl -sx torproxy:8118 https://whatismyipaddress.com/ \
    | grep 'Your IP' \
    | php -r '$result = trim(strip_tags(stream_get_contents(STDIN)));echo $result; exit($result?0:1);' \
    || curl -v -sx torproxy:8118 https://whatismyipaddress.com/
echo
echo . . . . . socks5 with torproxy . . . . . . . .
curl -sx socks5://torproxy:9050 https://whatismyipaddress.com/ \
    | grep 'Your IP' \
    | php -r '$result = trim(strip_tags(stream_get_contents(STDIN)));echo $result; exit($result?0:1);' \
    || curl -v -sx socks5://torproxy:9050 https://whatismyipaddress.com/
echo
echo . . . . . socks5 with torproxy.localhost . . .
curl -sx socks5://torproxy.localhost:9050 https://whatismyipaddress.com/ \
    | grep 'Your IP' \
    | php -r '$result = trim(strip_tags(stream_get_contents(STDIN)));echo $result; exit($result?0:1);' \
    || curl -v -sx socks5://torproxy.localhost:9050 https://whatismyipaddress.com/
echo
echo . . . . Direct + UA . . . . . . . . . . . . .
curl -sA "$UA" https://whatismyipaddress.com/ \
    | grep '<strong>IPv4:</strong>' \
    | php -r 'echo trim(strip_tags(stream_get_contents(STDIN)));' \
    || curl -sA "$UA" https://whatismyipaddress.com/
echo
