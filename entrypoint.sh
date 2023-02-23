#!/bin/bash -ex

# ===================
# cloned from docker image

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load DokuWiki environment
. /opt/bitnami/scripts/dokuwiki-env.sh

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libwebserver.sh

print_welcome_page

# if [[ "$1" = "/opt/bitnami/scripts/$(web_server_type)/run.sh" || "$1" = "/opt/bitnami/scripts/nginx-php-fpm/run.sh" ]]; then
info "** Starting DokuWiki setup **"
/opt/bitnami/scripts/"$(web_server_type)"/setup.sh
/opt/bitnami/scripts/php/setup.sh
/opt/bitnami/scripts/dokuwiki/setup.sh
/post-init.sh
info "** DokuWiki setup finished! **"
# fi

# end copy/paste
# ========================


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

# exec /opt/bitnami/apache/bin/httpd -DFOREGROUND -f /opt/bitnami/apache/conf/httpd.conf
exec /opt/bitnami/scripts/apache/run.sh
