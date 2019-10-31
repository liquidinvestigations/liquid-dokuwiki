#!/bin/bash -ex


# Usage:
# add-plugin.sh NAME REPO HASH

# Example:
# add-plugin.sh addnewpage https://github.com/samwilson/dokuwiki-plugin-addnewpage 9856122f05a5d8cedc363634e34b016249564f92

NAME=$1
REPO=$2
HASH=$3

curl -L $REPO/archive/$HASH.zip -o /tmp/$NAME.zip
unzip /tmp/$NAME.zip -d /tmp/$NAME
ROOT=$(find /tmp/$NAME -type d -maxdepth 1 -mindepth 1)
mv $ROOT /liquid/plugins/$NAME
rm -rf /tmp/$NAME.zip /tmp/$NAME
