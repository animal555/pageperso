#!/usr/bin/bash

cd $(dirname "$0") && ./mkDirListings.sh && make -B && cd cs205-2425 && make -B && cd .. && rclone sync --exclude ".git/**" . grgdf:cpradic
