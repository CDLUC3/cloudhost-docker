# image: cloudhost
ARG JAVA_VERSION=8
FROM openjdk:${JAVA_VERSION}
LABEL "org.cdlib.uc3"="Cloudhost docker v.1"  \
      "maintainer"="mark.reyes@ucop.edu"
RUN echo "Building Cloudhost docker image"


# ############################################################
# Environment
# ############################################################

# From Cloudhost start scripts
ENV ROLE cloudhost
ENV PW cdluc3
ENV CLOUDHOST_SSL 30443
ENV CLOUDHOST_PORT 38080
ENV CLOUDHOST_NODE 8800

ENV WORKDIR /apps/${ROLE}
ENV CLOUDHOST_USER ${ROLE}

# Set Java env
ENV CLASSPATH ${WORKDIR}/cloudhost:.

# Build this from source once repo is public?
ENV ARTIFACT "http://builds.cdlib.org/view/Merritt/job/mrt-cloudhost-pub/ws/cloudhost-jetty/target/mrt-cloudhostjetty-1.0-SNAPSHOT.jar"

# ############################################################
# Set up cloudhost user
# ############################################################
# Data directory: /apps/${ROLE}/fileCloud
# Log directory: /apps/${ROLE}/logs
# Application directory: /apps/${ROLE}/cloudhost
RUN groupadd -r ${CLOUDHOST_USER} && \
    useradd -d ${WORKDIR} -g ${CLOUDHOST_USER} ${CLOUDHOST_USER} && \
    mkdir -p /apps/${ROLE} && \
    chown -R ${CLOUDHOST_USER}:${CLOUDHOST_USER} /apps/${ROLE}

USER ${CLOUDHOST_USER}
RUN mkdir /apps/${ROLE}/cloudhost && \
    mkdir /apps/${ROLE}/cloudhost/etc && \
    mkdir /apps/${ROLE}/bin && \
    mkdir -p /apps/${ROLE}/fileCloud && \
    mkdir -p /apps/${ROLE}/logs

# Bytecode
RUN curl --silent --location \
         --output /apps/${ROLE}/cloudhost/mrt-cloudhost-1.0.jar \
	 ${ARTIFACT}

# Certificate
COPY data/etc/keystore.jks /apps/${ROLE}/cloudhost/etc/
# These may be useful to users
COPY zip/cloudhost/cshrunlog.sh ${WORKDIR}/bin/
COPY zip/cloudhost/cshrun.sh ${WORKDIR}/bin/
COPY zip/cloudhost/sslstate.sh ${WORKDIR}/bin/
COPY zip/cloudhost/state.sh ${WORKDIR}/bin/
COPY zip/cloudhost/testrun.sh ${WORKDIR}/bin/
COPY zip/cloudhost/README.txt ${WORKDIR}/bin/

# Start scripts and work area
RUN chown ${CLOUDHOST_USER}:${CLOUDHOST_USER} ${WORKDIR}
USER root
RUN chown -R ${CLOUDHOST_USER}:${CLOUDHOST_USER} ${WORKDIR}
RUN chmod 777 ${WORKDIR}/bin/cshrunlog.sh
RUN chmod 777 ${WORKDIR}/bin/cshrun.sh
# Eliminate any permission issue
RUN chmod 777 -R ${WORKDIR}

# ############################################################
# Expose system
# ############################################################
EXPOSE ${CLOUDHOST_PORT}/tcp
EXPOSE ${CLOUDHOST_SSL}/tcp
VOLUME ${WORKDIR}/cloudhost

USER ${CLOUDHOST_USER}
CMD /apps/${ROLE}/bin/cshrunlog.sh ${CLOUDHOST_SSL} ${CLOUDHOST_PORT} ${CLOUDHOST_NODE}
