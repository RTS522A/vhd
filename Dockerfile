FROM microsoft/iis:nanoserver
##################################################################################
# dockerhub : https://hub.docker.com/r/microsoft/iis/
# dockerfile: https://github.com/Microsoft/iis-docker/blob/master/nanoserver/Dockerfile
##################################################################################


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
ADD hyper/virtio-win /hyper/virtio-win
RUN powershell -Command \
  $ErrorActionPreference = 'Stop'; \
	pnputil /add-driver 'c:\hyper\virtio-win\vioserial\2k16\amd64\vioser.inf' /install; \
	pnputil /add-driver 'c:\hyper\virtio-win\NetKVM\2k16\amd64\netkvm.inf'    /install; \
  pnputil /add-driver 'c:\hyper\virtio-win\vioscsi\2k16\amd64\vioscsi.inf'  /install; \
	pnputil /add-driver 'c:\hyper\virtio-win\viostor\2k16\amd64\viostor.inf'  /install


RUN powershell -Command \
  $ErrorActionPreference = 'Stop'; \
  pnputil /add-driver 'c:\hyper\virtio-win\Balloon\2k16\amd64\balloon.inf'   /install; \
  pnputil /add-driver 'c:\hyper\virtio-win\pvpanic\2k16\amd64\pvpanic.inf'   /install; \
  pnputil /add-driver 'c:\hyper\virtio-win\vioinput\2k16\amd64\vioinput.inf' /install; \
	pnputil /add-driver 'c:\hyper\virtio-win\viorng\2k16\amd64\viorng.inf'     /install


###########################################
# add hyperstart.exe and serial port driver
###########################################
ADD hyper/reg /hyper/reg
ADD hyper/msports-driver /hyper/msports-driver
ADD hyper/hyperstart.exe /hyper/hyperstart.exe


###########################################
# install hyperstart service
###########################################
RUN powershell -Command \
  $ErrorActionPreference = 'Stop'; \
	c:\hyper\hyperstart.exe -install


######################################
EXPOSE 80
ENTRYPOINT ["C:\\ServiceMonitor.exe", "w3svc"]
