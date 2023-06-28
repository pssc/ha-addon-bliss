#!/usr/bin/with-contenv bashio
# ==============================================================================
# Community Hass.io Add-ons: generic cont-init
# ==============================================================================

CONFIG="/data/options.json"
OPTION=".dirs"
COMMAND="mkhadir"

function mkhadir {
  V=$1
  mkdir -p "${V}" || true
  chown ${HA_USER:-"root"}:${HA_GROUP:-"root"} "${V}"
  chmod ${HA_DIRS_MODE:-"g+rws"} "${V}"
  echo mkhadir "${V}"
}

if [ -r "${CONFIG}" ];then
  S=$(jq --raw-output "${OPTION} | length |@sh" ${CONFIG})

  for (( i=0; i < "${S}"; i++ )); do
    V=$(jq --raw-output "${OPTION}[$i]" ${CONFIG})
    ${COMMAND} ${V}
  done
fi

for i in ${HA_DIRS};do
#  if [ ! -r "${i}" ];then
     ${COMMAND} "${i}"
#  fi
done
