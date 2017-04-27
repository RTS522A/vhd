FROM microsoft/nanoserver
##################################################################################
# dockerhub : https://hub.docker.com/r/microsoft/iis/
# dockerfile: https://github.com/Microsoft/iis-docker/blob/master/nanoserver/Dockerfile
##################################################################################

###########################################
# add IIS Package
###########################################
ADD https://az880830.vo.msecnd.net/nanoserver-ga-2016/Microsoft-NanoServer-IIS-Package_base_10-0-14393-0.cab /install/Microsoft-NanoServer-IIS-Package_base_10-0-14393-0.cab
ADD https://az880830.vo.msecnd.net/nanoserver-ga-2016/Microsoft-NanoServer-IIS-Package_English_10-0-14393-0.cab /install/Microsoft-NanoServer-IIS-Package_English_10-0-14393-0.cab
ADD ServiceMonitor.exe /ServiceMonitor.exe

RUN dism.exe /online /add-package /packagepath:c:\install\Microsoft-NanoServer-IIS-Package_base_10-0-14393-0.cab & \
    dism.exe /online /add-package /packagepath:c:\install\Microsoft-NanoServer-IIS-Package_English_10-0-14393-0.cab & \
    dism.exe /online /add-package /packagepath:c:\install\Microsoft-NanoServer-IIS-Package_base_10-0-14393-0.cab & \
    rd /s /q c:\install

###########################################
# add OEM drivers
###########################################
ADD https://az880830.vo.msecnd.net/nanoserver-ga-2016/Microsoft-NanoServer-OEM-Drivers-Package_base_10-0-14393-0.cab /install/Microsoft-NanoServer-OEM-Drivers-Package_base_10-0-14393-0.cab
ADD https://az880830.vo.msecnd.net/nanoserver-ga-2016/Microsoft-NanoServer-OEM-Drivers-Package_English_10-0-14393-0.cab /install/Microsoft-NanoServer-OEM-Drivers-Package_English_10-0-14393-0.cab

RUN dism.exe /online /add-package /packagepath:c:\install\Microsoft-NanoServer-OEM-Drivers-Package_base_10-0-14393-0.cab /Quiet /NoRestart & \
    dism.exe /online /add-package /packagepath:c:\install\Microsoft-NanoServer-OEM-Drivers-Package_English_10-0-14393-0.cab /Quiet /NoRestart & \
    dism.exe /online /add-package /packagepath:c:\install\Microsoft-NanoServer-OEM-Drivers-Package_base_10-0-14393-0.cab /Quiet /NoRestart & \
    rd /s /q c:\install


###########################################
# install virtio driver
###########################################
ADD virtio-win /hyper/virtio-win
RUN powershell -Command \
  $ErrorActionPreference = 'Stop'; \
	pnputil /add-driver 'c:\hyper\virtio-win\vioserial\2k16\amd64\vioser.inf'; \
	pnputil /add-driver 'c:\hyper\virtio-win\NetKVM\2k16\amd64\netkvm.inf'; \
  pnputil /add-driver 'c:\hyper\virtio-win\vioscsi\2k16\amd64\vioscsi.inf'; \
	pnputil /add-driver 'c:\hyper\virtio-win\viostor\2k16\amd64\viostor.inf'


RUN powershell -Command \
  $ErrorActionPreference = 'Stop'; \
  pnputil /add-driver 'c:\hyper\virtio-win\Balloon\2k16\amd64\balloon.inf'; \
  pnputil /add-driver 'c:\hyper\virtio-win\pvpanic\2k16\amd64\pvpanic.inf'; \
  pnputil /add-driver 'c:\hyper\virtio-win\vioinput\2k16\amd64\vioinput.inf'; \
	pnputil /add-driver 'c:\hyper\virtio-win\viorng\2k16\amd64\viorng.inf'


###########################################
# add hyperstart.exe and serial port driver
###########################################
ADD hyper /hyper

RUN powershell -Command \
  $ErrorActionPreference = 'Stop'; \
  pnputil /add-driver 'c:\hyper\msports-driver\msports.inf'; \
  pnputil /add-driver 'c:\hyper\network-driver\e1000\nete1g3e.inf'; \
  pnputil /add-driver 'c:\hyper\network-driver\netkvm\netkvm.inf'; \
  pnputil /add-driver 'c:\hyper\network-driver\rtl8139\netrtl64.inf'


###########################################
# install hyperstart service
###########################################
ADD hyper/hyperstart.exe /hyper/hyperstart.exe
## (install hyeprstartservice make container can not run in windows)
RUN powershell -Command \
  $ErrorActionPreference = 'Stop'; \
	c:\hyper\hyperstart.exe -install


######################################
EXPOSE 80
CMD ["C:\\ServiceMonitor.exe", "w3svc"]
