#!/bin/bash
# run in git-bash of windows

echo "----- remove old container nano-mysql -----"
docker rm -fv nano-hyper >/dev/null 2>&1

echo "----- run new container nano-hyper -----"
docker run -d -P --name nano-hyper xjimmyshcn/nanoserver-hyper

echo "----- show container nano-hyper ------"
docker ps --filter name=nano-hyper
