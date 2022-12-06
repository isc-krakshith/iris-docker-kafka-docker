ARG IMAGE=intersystems/iris-community:2022.1.0.191.0
ARG IMAGE=intersystemsdc/iris-community:latest
FROM $IMAGE

USER root

WORKDIR /opt/kafka
RUN chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /opt/kafka
USER ${ISC_PACKAGE_MGRUSER}

COPY Installer.cls .
COPY Kafka /usr/irissys/mgr/src
COPY iris.script /tmp/iris.script

#revert user
USER ${ISC_PACKAGE_MGRUSER}

# run iris and initial 
RUN iris start $ISC_PACKAGE_INSTANCENAME \
	&& iris session IRIS < /tmp/iris.script \
	&& iris stop $ISC_PACKAGE_INSTANCENAME quietly
