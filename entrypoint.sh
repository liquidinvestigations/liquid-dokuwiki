#!/bin/bash -e

# Cloned from:
# https://github.com/bitnami/bitnami-docker-dokuwiki/blob/e960874bc62aa061d6b1cb09aa678b923aee2145/0/debian-9/rootfs/app-entrypoint.sh

. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

print_welcome_page

if [[ "$1" == "nami" && "$2" == "start" ]] || [[ "$1" == "/init.sh" ]]; then
  nami_initialize apache php dokuwiki
fi


export DOKU=/bitnami/dokuwiki
# Overwrite the local configuration on container start
info "Overwriting conf/local.php..."
cp /liquid/conf/local.php $DOKU/conf/local.php

for orig_path in $(find /liquid/plugins/ -type d -maxdepth 1 -mindepth 1); do
  plugin=$(basename "$orig_path")
  info "(Re)installing plugin $plugin..."
  rm -rf "$DOKU/lib/plugins/$plugin"
  cp -a "/liquid/plugins/$plugin" "$DOKU/lib/plugins/$plugin"
done

info "Starting dokuwiki... "

# When apache does eventually boot, follow its logs
( while true; do tail -f /opt/bitnami/apache/logs/error_log || sleep 5; done ) &

exec tini -- "$@"
