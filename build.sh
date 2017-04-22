#!/bin/bash

cd hyper

###################################################################
echo "----- Download virtio-win -----"
curl -C - -O -s https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso

echo "----- mount virtio-win.iso -----"
PowerShell  -Command  Mount-DiskImage  -ImagePath  $PWD/virtio-win.iso

echo "----- Get Virtual CDROM driver letter -----"
ISODRV=$(powershell -Command Get-Volume | grep virtio-win | awk '{print $1}' | head -n1)
if [ ${ISODRV} == "" ];then
  echo "Can not mount virtio-win.iso, quit"
  exit 1
fi

echo "----- Find Driver for win 2k16 -----"
find "/${ISODRV}/" | grep 2k16$

echo "----- Cpoy Driver for win 2k16 -----"
mkdir -p virtio-win
for i in $(find "/${ISODRV}/" | grep 2k16$)
do
  DIRDRV=$(echo $i | cut -d'/' -f3)
  mkdir -p virtio-win/${DIRDRV}/2k16
  cp $i/* virtio-win/${DIRDRV}/2k16/ -rf
done
ls virtio-win

echo "----- dismount virtio-win.iso -----"
PowerShell  -Command  Dismount-DiskImage  -ImagePath  $PWD/virtio-win.iso

###################################################################
echo "----- Build -----"
cd ..
docker build -t xjimmyshcn/nanoserver-hyper .
