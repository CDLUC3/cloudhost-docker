ucdn-docker
===========

Configuration for the UCDN project

Deploying new configurations
----------------------------

Define host ports and mount points to map with Docker ports and mounts.

- docker build --tag=cdluc3/ucdn .
- docker run \
        --detach \
        --name ${NAME} \
        --publish ${PORT_SSL}:30443 \
        --publish ${PORT_HTTP}:38080 \
        --volume ${DATADIR}:/apps/ucdn/fileCloud \
        --volume ${LOGDIR}:/apps/ucdn/logs \
        cdluc3/ucdn

Now point browser to https://localhost:${PORT_HTTP}/cloudhost/state/8100?t=xml on linux to check status
Check log directory to see confirm UCDN is logging correctly

### Admin tools

Stop/Start container
- docker container stop ${NAME}
- docker container start ${NAME}

Examine Docker container to check for debugging
- docker exec -it ${NAME} /bin/bash

