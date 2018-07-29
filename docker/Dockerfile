FROM library/openjdk:8

MAINTAINER linjinze <linjinze999@163.com>

# Overridable defaults
ENV GERRIT_HOME /home/gerrit
ENV GERRIT_SITE ${GERRIT_HOME}/review_site
ENV GERRIT_WAR ${GERRIT_HOME}/gerrit.war
ENV GERRIT_VERSION 2.14.9
ENV GERRIT_USER gerrit
ENV GERRIT_INIT_ARGS ""

RUN set -x && \
    apt-get update && DEBIAN_FRONTEND=nointeractive apt-get install -y --no-install-recommends \
      curl \
      dirmngr \
      git \
      gitweb \
      gnupg \
      vim \
      libcgi-pm-perl \
      netcat \
      procmail \
      openssh-client \
      wget\
    && rm -rf /var/lib/apt/lists/*

#A directory has to be created before a volume is mounted to it.
RUN mkdir /docker-entrypoint-init.d && mkdir -p $GERRIT_HOME && mkdir -p $GERRIT_SITE

#Copy gerrit.war
COPY gerrit-${GERRIT_VERSION}.war $GERRIT_WAR

#Copy Plugins:
COPY ./plugins_download ${GERRIT_HOME}/plugins_download

#Copy hooks:
#COPY ./hooks_download ${GERRIT_HOME}/hooks_download

#Copy etc
COPY ./etc_download ${GERRIT_HOME}/etc_download

#Copy lib
COPY ./lib_download ${GERRIT_HOME}/lib_download

# Use tini as subreaper in Docker container to adopt zombie processes
ENV TINI_VERSION 0.18.0
COPY tini-static-amd64 /sbin/tini
#ADD https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini-static-amd64 /sbin/tini
RUN chmod +x /sbin/tini

# Ensure the entrypoint scripts are in a fixed location
COPY gerrit-entrypoint.sh /
COPY gerrit-start.sh /
RUN chmod +x /gerrit*.sh


#Gerrit site directory is a volume, so configuration and repositories
#can be persisted and survive image upgrades.
VOLUME $GERRIT_SITE

ENTRYPOINT ["/sbin/tini", "--", "/gerrit-entrypoint.sh"]

EXPOSE 8080 29418

CMD ["/gerrit-start.sh"]
