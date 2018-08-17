UCDN Docker
===========

This is the build and deployment instructions for the UCDN service under Docker.

Requirements
------------

- Docker 
- If Docker is run as non-root, user must have Docker privileges 
  https://docs.docker.com/install/linux/linux-postinstall/

Building Docker image
---------------------

This needs only be performed by UC3.  For others, the image will be served by Dockerhub. 

- docker build --tag=cdluc3/ucdn .

Deploying image
---------------

This will initialize the container and start the service.  This needs only be performed once
per UCDN instance.  See admin section for subsequent start/stop functions.

Define host ports and mount points to map with Docker ports and mounts.
Naming of your container is also available.  

- docker run \
        --detach \
        --name ${NAME} \
        --publish ${PORT_SSL}:30443 \
        --publish ${PORT_HTTP}:38080 \
        --volume ${DATADIR}:/apps/ucdn/fileCloud \
        --volume ${LOGDIR}:/apps/ucdn/logs \
        cdluc3/ucdn

Test the container
------------------

The following URL on the deployed host will check UCDN status:
    http://localhost:${PORT_HTTP}/cloudhost/state/8100?t=xml 

${DATADIR} will house the pairtree data.
${LOGDIR} will house the log files.

Administration tools
--------------------

To stop the UCDN service, just stop the container.  Same goes for starting.
Reference the container name defined during initialization.

Stop/Start container
- docker container stop ${NAME}
- docker container start ${NAME}

To examine UCDN container for debugging.
- docker exec -it ${NAME} /bin/bash

Template scripts
----------------

Provided scripts can be used as templates for much of the functionality described here.
