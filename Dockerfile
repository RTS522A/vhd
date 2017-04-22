FROM microsoft/nanoserver
#REF: https://github.com/Microsoft/Virtualization-Documentation/blob/live/windows-container-samples/mysql/Dockerfile

###########################################
# add hyperstart.exe and serial port driver
###########################################
ADD hyper/hyperstart.exe /hyper/hyperstart.exe
ADD hyper/reg /hyper/reg
ADD hyper/msports-driver /hyper/msports-driver
ADD hyper/virtio-win /hyper/virtio-win

###########################################
# install serial port driver
###########################################
RUN powershell -Command \
  $ErrorActionPreference = 'Stop'; \
	pnputil /add-driver 'c:\hyper\msports-driver\msports.inf' /install;

###########################################
# install virtio driver
###########################################
RUN powershell -Command \
  $ErrorActionPreference = 'Stop'; \
	pnputil /add-driver 'c:\hyper\virtio-win\Balloon\2k16\amd64\balloon.inf' /install; \
	pnputil /add-driver 'c:\hyper\virtio-win\NetKVM\2k16\amd64\netkvm.inf' /install; \
	pnputil /add-driver 'c:\hyper\virtio-win\pvpanic\2k16\amd64\pvpanic.inf' /install; \
	pnputil /add-driver 'c:\hyper\virtio-win\vioinput\2k16\amd64\vioinput.inf' /install; \
	pnputil /add-driver 'c:\hyper\virtio-win\viorng\2k16\amd64\viorng.inf' /install; \
	pnputil /add-driver 'c:\hyper\virtio-win\vioscsi\2k16\amd64\vioscsi.inf' /install; \
	pnputil /add-driver 'c:\hyper\virtio-win\vioserial\2k16\amd64\vioser.inf' /install; \
	pnputil /add-driver 'c:\hyper\virtio-win\viostor\2k16\amd64\viostor.inf' /install

###########################################
# install hyperstart service
###########################################
RUN powershell -Command \
  $ErrorActionPreference = 'Stop'; \
	c:\hyper\hyperstart.exe -install;

######################################
CMD [ "ping localhost -t" ]
