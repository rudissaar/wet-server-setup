#!/usr/bin/env bash
# Script that downloads common maps for Wolfenstein Enemy Territory from internet.

WET_USER='wet'
WET_DIR="/srv/${WET_USER}"
MAPS_URL='http://legacy.murda.eu/downloads/wet/maps/'

# You need root permissions to run this script.
if [[ "${UID}" != '0' ]]; then
    echo '> You need to become root to run this script.'
    echo '> Aborting.'
    exit 1
fi

if ! command -v wget 1> /dev/null 2>&1; then
    echo "> Unable to find wget from your environment's PATH variable."
    echo '> Aborting.'
    exit 1
fi

if [[ ! -d "${WET_DIR}" ]] || [[ ! -d "${WET_DIR}/etmain" ]]; then
    echo "> Destination directory doesn't exist (${WET_DIR}/etmain)."
    echo '> Aborting.'
    exit 1
fi

MAPS=( \
    'adlernest.pk3' \
    'braundorf_b4.pk3' \
    'bremen_b2.pk3' \
    'caen2.pk3' \
    'et_beach.pk3' \
    'et_ice.pk3' \
    'frostbite.pk3' \
    'karsiah_te2.pk3' \
    'missile_b3.pk3' \
    'reactor_final.pk3' \
    'sp_delivery_te.pk3' \
    'supply.pk3' \
    'sw_battery.pk3' \
    'sw_goldrush_te.pk3' \
    'tc_base.pk3' \
    'te_valhalla.pk3' \
    'tournementdm2.pk3' \
)

for MAP in "${MAPS[@]}"
do
    if [[ ! -f "${WET_DIR}/etmain/${MAP}" ]]; then
        wget "${MAPS_URL}${MAP}" -O "${WET_DIR}/etmain/${MAP}"
    fi
done

# Last correction for ownership and permissions.
chown -R "${WET_USER}:${WET_USER}" "${WET_DIR}"
chmod -R o-rwx "${WET_DIR}"

# Let user know that script has finished its job.
echo '> Finished.'

