#!/usr/bin/with-contenv bashio
# ==============================================================================

# Needs exec perms
mkdir -p /bliss-tmp
ln -s /bliss-tmp /tmp/bliss

if [ "${EULA:-false}" != "true" ]; then
   bashio::log.warning "Bliss EULA needs to be agreed"
   exit 1
fi
bashio::log.info "Bliss EULA agreed"

if [ ! -r /config/bliss/application/ha-install ];then
	   mv /config/bliss/application /config/bliss/application.sav
	   ln -s /data/bliss/application /config/bliss/application
fi 

DAEMON_SOFTWARE_INSTALLER=${DAEMON_SOFTWARE_DOWNLOAD_DIR}/$(basename $DAEMON_SOFTWARE_URL)
DAEMON_STARTUP=$DAEMON_INSTALL_DIR/bin/bliss.sh
# Download if required
if [ ! -r $DAEMON_SOFTWARE_INSTALLER -a ! -r $DAEMON_STARTUP ];then
   bashio::log.info "download"
   wget -O $DAEMON_SOFTWARE_INSTALLER $DAEMON_SOFTWARE_URL
fi

# Install if required
if [ ! -r $DAEMON_STARTUP -a -r $DAEMON_SOFTWARE_INSTALLER ];then
   bashio::log.info "install"
   (sleep 15; echo 1;sleep 15; echo $DAEMON_INSTALL_DIR; sleep 15;echo 1;sleep 90)  |$DAEMON_SOFTWARE_INSTALLER_COMMAND $DAEMON_SOFTWARE_INSTALLER
   if [ -r $DAEMON_STARTUP ];then
	   rm $DAEMON_SOFTWARE_INSTALLER
	   rm -f /config/bliss/reinstall
	   touch $DAEMON_INSTALL_DIR/ha-install
           bashio::log.info "installed"
   fi
fi

#copy user prefs
if [ -d /data/bliss/userprefs/bliss -a ! -r /config/bliss/debug ];then
   bashio::log.debug "copy user prefs"
   mkdir -p /config/bliss/java/.userPrefs/com/elsten
   rsync -art /data/bliss/userprefs/bliss /config/.java/.userPrefs/com/elsten/
fi
if [ -r /config/bliss/move ];then
	if [ -d /config/bliss/application ];then
	   cp -rp /config/bliss/application /data/bliss/
	   mv /config/bliss/application /config/bliss/application.sav
	   ln -s /data/bliss/application /config/bliss/application
	   rm /config/bliss/move
	fi
fi

