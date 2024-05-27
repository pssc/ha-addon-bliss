#!/usr/bin/with-contenv bashio
# ==============================================================================

# Needs exec perms
bashio::log.info "Finish Blissing"
CFG="/config/addons_config/bliss"

# For testing reinstall
if [ -r /config/bliss/reinstall ];then
        bashio::log.info "Reinstall Bliss software on next start"
	rm -fr /data/bliss/install
fi

# application config

mkdir -p /data/bliss/userprefs/
if [ -r /config/.java/.userPrefs/com/elsten/bliss ];then
   bashio::log.debug "copy Bliss user prefs"
   rsync -art /config/.java/.userPrefs/com/elsten/bliss /data/bliss/userprefs/
fi

if [ -r /data/bliss/application/settings ];then
  bashio::log.debug "copy Bliss app prefs"
  rsync -art /data/bliss/application/settings ${CFG}/settings
fi

bashio::log.info "Bliss Tidy logs"
rm -f /data/bliss/apllication/logs/bliss.log.*
: > /data/bliss/apllication/logs/bliss.log

# Todo tidy data and code..

# on debug?
bashio::log.info "Finish Bliss"
touch ${CFG}/finish
bashio::log.info "Finish Blissing End"
exit 0
