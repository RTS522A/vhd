#!/bin/bash

echo "##########################################"
echo "# run this script in git bash of windows #"
echo "##########################################"


echo "----- show HyperStartSerivce in windows registry -----"
winpty docker exec -it nano-hyper-iis powershell 'REG QUERY HKLM\system\CurrentControlSet\Services\HyperStartSerivce'

echo "----- show SerialPort in windows registry -----"
winpty docker exec -it nano-hyper-iis powershell 'REG QUERY HKEY_LOCAL_MACHINE\HARDWARE\DEVICEMAP\SERIALCOMM'

echo "----- show SerialPort via wmic -----"
winpty docker exec -it nano-hyper-iis powershell 'wmic path Win32_PnPEntity where "PNPClass=\'Ports\'" get "Name,PNPDeviceID,PNPClass,Status,Manufacturer,Service"'

echo "----- show process -----"
winpty docker exec -it nano-hyper-iis powershell Get-Process
