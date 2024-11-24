#!/usr/bin/bash

cd $(dirname "$0")
./mkDirListings.sh
make
rclone sync --exclude ".git/**" . grgdf:cpradic
