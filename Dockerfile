FROM microsoft/iis:nanoserver
##################################################################################
# dockerhub : https://hub.docker.com/r/microsoft/iis/
# dockerfile: https://github.com/Microsoft/iis-docker/blob/master/nanoserver/Dockerfile
##################################################################################

###########################################
# add drivers
###########################################
ADD drivers /drivers

# add serial port driver and network driver
RUN pnputil /add-driver c:\\drivers\\msports-driver\\msports.inf /install
RUN pnputil /add-driver c:\\drivers\\network-driver\\*.inf /subdirs /install


###########################################
# install hyperstart service
###########################################
ADD hyper /hyper
RUN c:\\hyper\\hyperstart.exe -install

EXPOSE 80
CMD ["ping","-t","localhost"]
ENTRYPOINT []
