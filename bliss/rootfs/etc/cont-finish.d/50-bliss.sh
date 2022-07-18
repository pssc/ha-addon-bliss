#!/usr/bin/with-contenv bashio
# ==============================================================================

# Needs exec perms
bashio::log.info "Finish Blissing"

# For testing reinstall
if [ -r /config/bliss/reinstall ];then
        bashio::log.info "Reinstall Bliss software on next start"
	rm -fr /data/bliss/install
fi

# application config

# Save userprefs.
mkdir -p /data/bliss/userprefs/
if [ -r /config/.java/.userPrefs/com/elsten/bliss ];then
   bashio::log.debug "copy Bliss user prefs"
   rsync -art /config/.java/.userPrefs/com/elsten/bliss /data/bliss/userprefs/
fi

# on debug?
bashio::log.info "Finish Bliss"
touch /config/bliss/finish
bashio::log.info "Finish Blissing End"
exit 0

# /config/bliss/application/code/
# Clean based on current-version
# iterate check current and older than ... 6months?
