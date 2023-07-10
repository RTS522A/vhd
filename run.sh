#!/bin/bash
# run in git-bash of windows

echo "----- remove old container -----"
docker rm -fv nano-demo >/dev/null 2>&1

echo "----- run new container -----"
docker run -d -P --name nano-demo hyperhq/nanoserver-demo

echo "----- show container ------"
docker ps --filter name=nano-demo
