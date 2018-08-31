#!/usr/bin/env bash

# --------------
# user settings
# --------------
# Ports
PORT_HTTP=38080
PORT_SSL=30443

# Bind mount
LOGDIR=~/merritt/ucdn/logs
DATADIR=~/merritt/ucdn/fileCloud

# Container name
NAME=ucdn

# Create container
docker run \
	--detach \
	--restart unless-stopped \
	--name ${NAME} \
	--publish ${PORT_SSL}:30443 \
	--publish ${PORT_HTTP}:38080 \
	--volume ${DATADIR}:/apps/ucdn/fileCloud \
	--volume ${LOGDIR}:/apps/ucdn/logs \
	cdluc3/ucdn

exit
