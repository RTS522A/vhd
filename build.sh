#!/bin/bash

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

mkdir drivers/virtio-win/{1,2}
mv virtio-win/{vioscsi,vioserial,viostor} drivers/virtio-win/1
mv virtio-win/{Balloon,pvpanic,vioinput,viorng} drivers/virtio-win/2
find ./drivers/virtio-win/ -name "*.pdb" | xargs -i rm -rf {}


echo "----- dismount virtio-win.iso -----"
PowerShell  -Command  Dismount-DiskImage  -ImagePath  $PWD/virtio-win.iso

###################################################################
echo "----- Build -----"
docker build -t hyperhq/nanoserver-demo .
