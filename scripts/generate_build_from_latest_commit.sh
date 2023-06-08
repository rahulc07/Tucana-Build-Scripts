#!/bin/bash
cd /home/rahul/lfs/build-scripts

git log --raw | sed -n "1,/commit/{/commit/,/commit/p}" | sed '$d' | sed -e '1,6d' | cut -f2- | sed 's/^/bash\ /' > ~/build_commit.sh
