#!/usr/bin/with-contenv bashio
# ==============================================================================
# Community Hass.io Add-ons: bliss
# Set up env from ha addon from options
# ==============================================================================

function ha_to_env {
  KEY=$1
  PRE=${2:-""}
  VAL=$(bashio::config "${KEY,,}")
  bashio::log.info "Option ${KEY} to ${PRE}${KEY}""=""${VAL}"
  if [[ "${VAL}" != "null" ]];then
    echo -n ${VAL} >/run/s6/container_environment/${PRE}${KEY}
  fi
}

PF="LMS_"

ha_to_env EULA
#ha_to_env NX ${PF}
exit
