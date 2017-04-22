FROM microsoft/nanoserver
#REF: https://github.com/Microsoft/Virtualization-Documentation/blob/live/windows-container-samples/mysql/Dockerfile

# add serial port driver
ADD driver /driver

# install serial port driver
RUN powershell -Command \
  $ErrorActionPreference = 'Stop'; \
	pnputil /add-driver 'c:\driver\msports.inf' /install;

# add hyperstart
ADD hyper /hyper

# register hyperstart service
RUN powershell -Command \
  $ErrorActionPreference = 'Stop'; \
	c:\hyper\hyperstart.exe -install;

# add virtio driver
ADD virtio-win /virtio-win

# install virtio driver
RUN powershell -Command \
  $ErrorActionPreference = 'Stop'; \
	pnputil /add-driver 'c:\virtio-win\Balloon\2k16\amd64\balloon.inf' /install; \
	pnputil /add-driver 'c:\virtio-win\NetKVM\2k16\amd64\netkvm.inf' /install; \
	pnputil /add-driver 'c:\virtio-win\pvpanic\2k16\amd64\pvpanic.inf' /install; \
	pnputil /add-driver 'c:\virtio-win\vioinput\2k16\amd64\vioinput.inf' /install; \
	pnputil /add-driver 'c:\virtio-win\viorng\2k16\amd64\viorng.inf' /install; \
	pnputil /add-driver 'c:\virtio-win\vioscsi\2k16\amd64\vioscsi.inf' /install; \
	pnputil /add-driver 'c:\virtio-win\vioserial\2k16\amd64\vioser.inf' /install; \
	pnputil /add-driver 'c:\virtio-win\viostor\2k16\amd64\viostor.inf' /install

CMD [ "ping localhost -t" ]
