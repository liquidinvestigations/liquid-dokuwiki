#!/bin/bash -ex

# Cloned from:
# https://github.com/bitnami/bitnami-docker-dokuwiki/blob/e960874bc62aa061d6b1cb09aa678b923aee2145/0/debian-9/rootfs/app-entrypoint.sh

. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

print_welcome_page
nami_initialize apache php dokuwiki

# Overwrite the local configuration
export DOKU=/bitnami/dokuwiki
info "Overwriting conf/local.php..."
cp /liquid/conf/local.protected.php $DOKU/conf/local.protected.php
info "Overwriting conf/plugins.protected.php..."
cp /liquid/conf/plugins.protected.php $DOKU/conf/plugins.protected.php

# Overwrite plugins with the ones under /liquid/plugins/
for orig_path in $(find /liquid/plugins/ -type d -maxdepth 1 -mindepth 1); do
  plugin=$(basename "$orig_path")
  info "(Re)installing plugin $plugin..."
  rm -rf "$DOKU/lib/plugins/$plugin"
  cp -a "/liquid/plugins/$plugin" "$DOKU/lib/plugins/$plugin"
done

# Overwrite the "liquid" theme
rm -rf "$DOKU/lib/tpl/liquid"
cp -a "/liquid/tpl/liquid" "$DOKU/lib/tpl/liquid"

# Overwrite the "tools:index" page
mkdir -p "$DOKU/data/pages/tools"
cp /liquid/conf/sitemap.txt "$DOKU/data/pages/tools/index.txt"


# Overwrite the liquid-envs.conf HTTPD config
cp -av /liquid/conf/httpd/liquid-envs.conf /opt/bitnami/apache/conf/vhosts/liquid-envs.conf


info "Starting dokuwiki... "

# When apache does eventually boot, follow its logs
tail -F /opt/bitnami/apache/logs/error_log &

exec /opt/bitnami/apache/bin/httpd -DFOREGROUND -f /opt/bitnami/apache/conf/httpd.conf
