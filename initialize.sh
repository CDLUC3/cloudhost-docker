#!/usr/bin/env bash

# -------------------------
# START user settings START
# -------------------------
# Container name
NAME=ucdn

# Ports
PORT_HTTP=38080
PORT_SSL=30443

# Bind mount
LOGDIR=/home/mreyes/UCDN/logs
DATADIR=/home/mreyes/UCDN/fileCloud

# User and Group ID that owns data/logs (default to root)
UserID=0
GroupID=0
# --------------------
# END user settings END
# ---------------------

if [ ! -d "${LOGDIR}" ]; then
   mkdir ${LOGDIR}
   chown -R ${UserID}:${GroupID} ${LOGDIR}
fi
if [ ! -d "${DATADIR}" ]; then
   mkdir ${DATADIR}
   chown -R ${UserID}:${GroupID} ${DATADIR}
fi

# Create container
docker run \
	--detach \
	--restart unless-stopped \
        --user ${UserID}:${GroupID} \
	--name ${NAME} \
	--publish ${PORT_SSL}:30443 \
	--publish ${PORT_HTTP}:38080 \
	--volume ${DATADIR}:/apps/ucdn/fileCloud \
	--volume ${LOGDIR}:/apps/ucdn/logs \
	cdluc3/ucdn

exit
