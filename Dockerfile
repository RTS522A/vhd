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

CMD [ "ping localhost -t" ]
