# image: ucdn-docker
ARG JAVA_VERSION=8
FROM openjdk:${JAVA_VERSION}
LABEL "org.cdlib.uc3"="UCDN docker v.1"  \
      "maintainer"="mark.reyes@ucop.edu"
RUN echo "Building UCDN docker image"


# ############################################################
# Environment
# ############################################################

# From UCDN start scripts
ENV ROLE ucdn
ENV PW cdluc3
ENV CLOUDHOST_SSL 30443
ENV CLOUDHOST_PORT 38080

ENV WORKDIR /apps/${ROLE}
ENV UCDN_USER ${ROLE}

# Set Java env
ENV CLASSPATH ${WORKDIR}/cloudhost:.

# Build this from source once repo is public?
ENV ARTIFACT "http://builds.cdlib.org/view/Merritt/job/mrt-cloudhost-pub/ws/cloudhost-jetty/target/mrt-cloudhostjetty-1.0-SNAPSHOT.jar"

# ############################################################
# Set up Ucdn user
# ############################################################
# Data directory: /apps/${ROLE}/fileCloud
# Log directory: /apps/${ROLE}/logs
# Application directory: /apps/${ROLE}/cloudhost
RUN groupadd -r ${UCDN_USER} && \
    useradd -d ${WORKDIR} -g ${UCDN_USER} ${UCDN_USER} && \
    mkdir -p /apps/${ROLE} && \
    chown -R ${UCDN_USER}:${UCDN_USER} /apps/${ROLE}

USER ${UCDN_USER}
RUN mkdir /apps/${ROLE}/cloudhost && \
    mkdir /apps/${ROLE}/cloudhost/etc && \
    mkdir /apps/${ROLE}/bin && \
    mkdir /apps/${ROLE}/fileCloud && \
    mkdir /apps/${ROLE}/logs

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
USER root
RUN chmod +x ${WORKDIR}/bin/cshrunlog.sh
RUN chmod +x ${WORKDIR}/bin/cshrun.sh
RUN chown -R ${UCDN_USER}:${UCDN_USER} ${WORKDIR}
USER ${UCDN_USER}

# ############################################################
# Expose system
# ############################################################
EXPOSE ${CLOUDHOST_PORT}/tcp
EXPOSE ${CLOUDHOST_SSL}/tcp
VOLUME ${WORKDIR}/cloudhost

CMD /apps/${ROLE}/bin/cshrunlog.sh ${CLOUDHOST_SSL} ${CLOUDHOST_PORT}
