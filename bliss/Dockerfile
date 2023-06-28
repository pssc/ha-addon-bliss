ARG BUILD_FROM=hassioaddons/debian-base:latest
FROM ${BUILD_FROM}
ARG target_uid=1000
ARG url="https://www.blisshq.com/downloads/bliss-install-20230606.jar?20230606&filename=downloads/bliss-install-20230606.jar"
ARG debug=false

ARG BUILD_ARCH

ENV S6_SERVICES_GRACETIME 119000
# Set for package install
ENV DEBIAN_FRONTEND "noninteractive" 
# TZ config at runtime
ENV DISABLE_HA_AUTHENTICATION true

ENV HA_USER "root"
ENV HA_GROUP "nogroup"
ENV HA_USER_UID ""
ENV DAEMON="bash /data/bliss/install/bin/bliss.sh"
ENV DAEMON_OPTIONS=" "
ENV DAEMON_EXTRA_OPTIONS=" "
ENV DAEMON_APP_DIR="/data/bliss/application"
ENV DAEMON_INSTALL_DIR="/data/bliss/install"
ENV DAEMON_SOFTWARE_URL=$url
ENV DAEMON_SOFTWARE_DOWNLOAD_DIR="/data/bliss/download"
ENV DAEMON_SOFTWARE_INSTALLER_COMMAND "java -jar"

#Download to /tmp after testing.
ENV HA_DIRS="/data/music /config/.java /data/bliss/download /data/bliss/application /config/addons_config/bliss /data/bliss/install"
ENV DEBUG=$debug
#/config/bliss/java/.userPrefs/com/elsten/bliss/licence/prefs.xml

COPY rootfs/ /

# FIX For jdk install
RUN mkdir -p /usr/share/man/man1

RUN apt-get update && \
	apt-get -y install --no-install-recommends \
		nfs-common \
		udev \
		lvm2 \
		patch \
		default-jdk-headless \
		wget \
		rsync \
		tzdata 

RUN if [[ ! -z "${debug}" ]];then apt-get -y install vim less procps strace;fi

RUN ln -s ${DAEMON_APP_DIR}  /$(getent passwd ${HA_USER} | cut -d : -f 6)/.bliss
RUN ln -s /config/.java /$(getent passwd ${HA_USER} | cut -d : -f 6)/.java

# Nginx Ingress support
#RUN apt-get install -y --no-install-recommends \
#        libnginx-mod-http-lua \
#        luarocks \
#        nginx \
#    && luarocks install lua-resty-http 0.15-0 \
#    && rm -r /etc/nginx
#COPY rootfs-ingress/ /

#COPY patch /sources/
#RUN for i in /sources/*.patch;do patch -d / -p1 -i $i;done

#Cleanup
RUN if [ -z "${debug}" -o "${debug}" = "false" ];then apt-get -y remove \
           git \
           && \
	apt-get clean -y && \
	apt-get -y autoremove && \
        rm -fr /sources ;fi

VOLUME /data
VOLUME /share
VOLUME /backup
VOLUME /config

# Build arguments
ARG BUILD_DATE
ARG BUILD_REF
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="bliss" \
    io.hass.description="Bliss Application" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Phillip Camp <phillip.camp+ha<removeme>@gmail.com>" \
    org.label-schema.description="Bliss Application" \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.name="bliss" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.usage="https://github.com/pssc/ha-addon-bliss/tree/master/README.md" \
    org.label-schema.vcs-ref=${BUILD_REF} \
    org.label-schema.vcs-url="https://github.com/pssc/ha-addon-bliss" \
    org.label-schema.vendor="pssc"
#    org.label-schema.url="https://community.home-assistant.io/t/home-assistant-community-add-on-portainer/68836?u=pssc"
