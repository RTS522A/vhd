#!/bin/bash
# run in git-bash of windows

echo "----- remove old container nano-mysql -----"
docker rm -fv nano-hyper-iis >/dev/null 2>&1

echo "----- run new container nano-hyper-iis -----"
docker run -d -P --name nano-hyper-iis xjimmyshcn/nanoserver-hyper-iis

echo "----- show container nano-hyper-iis ------"
docker ps --filter name=nano-hyper-iis
