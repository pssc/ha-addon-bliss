#!/usr/bin/with-contenv bashio
# ==============================================================================

CFG="/config/addons_config/bliss"
# Needs exec perms
mkdir -p /bliss-tmp
ln -s /bliss-tmp /tmp/bliss

if [ "${EULA:-false}" != "true" ]; then
   bashio::log.warning "Bliss EULA needs to be agreed"
   exit 1
fi
bashio::log.info "Bliss EULA agreed"

DAEMON_SOFTWARE_INSTALLER=${DAEMON_SOFTWARE_DOWNLOAD_DIR}/$(basename $DAEMON_SOFTWARE_URL)
DAEMON_STARTUP=$DAEMON_INSTALL_DIR/bin/bliss.sh
# Download if required
if [ ! -r $DAEMON_SOFTWARE_INSTALLER -a ! -r $DAEMON_STARTUP ];then
   bashio::log.info "Download $DAEMON_SOFTWARE_URL"
   wget -O $DAEMON_SOFTWARE_INSTALLER $DAEMON_SOFTWARE_URL
fi

# Install if required
if [ ! -r $DAEMON_STARTUP -a -r $DAEMON_SOFTWARE_INSTALLER ];then
   bashio::log.info "install this can take some time..."
   (sleep 15; echo 1;sleep 15; echo $DAEMON_INSTALL_DIR; sleep 15;echo 1;sleep 90)  |$DAEMON_SOFTWARE_INSTALLER_COMMAND $DAEMON_SOFTWARE_INSTALLER
   if [ -r $DAEMON_STARTUP ];then
	   rm $DAEMON_SOFTWARE_INSTALLER
           # reinstall in finish
	   rm -f ${CFG}/reinstall
	   touch $DAEMON_INSTALL_DIR/ha-install
           bashio::log.info "installed"
   fi
fi

# Copy user prefs from last finish script, but not on debug
if [ -d /data/bliss/userprefs/bliss -a ! -r ${CFG}/debug ];then
   bashio::log.debug "Copy user prefs"
   mkdir -p /config/.java/.userPrefs/com/elsten
   rsync -art /data/bliss/userprefs/bliss /config/.java/.userPrefs/com/elsten/
   if [ -r ${CFG}/settings ];then
       bashio::log.debug "Copy app prefs"
       rsync -art ${CFG}/settings /data/bliss/application/settings
   else
       bashio::log.debug "del app prefs"
       rm /data/bliss/application/settings
   fi
else
   bashio::log.info "Skip user app/prefs"
fi

