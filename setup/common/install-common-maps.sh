#!/usr/bin/env bash

WET_DIR='/srv/wet'
MAPS_URL='http://legacy.murda.eu/downloads/wet/maps/'

if [[ "${UID}" != '0' ]]; then
    echo '> You need to become root to run this script.'
    exit 1
fi

if [[ ! -d "${WET_DIR}" ]] || [[ -d "${WET_DIR}/etmain" ]]; then
    echo "> Destination directory doesn't exist, terminating."
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

for MAP in ${MAPS[@]}
do
    if [[ ! -f "${WET_DIR}/etmain/${MAP}" ]]; then
        wget "${MAPS_URL}${MAP}" -O "${WET_DIR}/etmain/${MAP}"
    fi
done

# Last correction for ownership and permissions.
chown -R 'wet:wet' "${WET_DIR}"
chmod -R o-rwx "${WET_DIR}"

echo '> Finished.'

