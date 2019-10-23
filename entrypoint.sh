#!/bin/bash -e

# Cloned from:
# https://github.com/bitnami/bitnami-docker-dokuwiki/blob/e960874bc62aa061d6b1cb09aa678b923aee2145/0/debian-9/rootfs/app-entrypoint.sh

. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

print_welcome_page

if [[ "$1" == "nami" && "$2" == "start" ]] || [[ "$1" == "/init.sh" ]]; then
  nami_initialize apache php dokuwiki
fi

# Overwrite the local configuration on container start
info "Overwriting conf/local.php..."
cp /liquid/conf/local.php ./conf/local.php

for plugin in /liquid/plugins/*; do
  info "(Re)installing plugin $i..."
  rm -rf "./lib/plugins/$i"
  cp -av "/liquid/plugins/$i" "./lib/plugins/$i"
done

info "Starting dokuwiki... "

exec tini -- "$@"
