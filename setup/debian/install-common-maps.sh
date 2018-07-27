#!/usr/bin/env bash

WET_DIR='/srv/wet'
MAPS_URL='http://legacy.murda.eu/downloads/wet/maps/'

if [[ "${UID}" != '0' ]]; then
    echo '> You need to become root to run this script.'
    exit 1
fi

MAPS=( \
    'adlernest.pk3' \
    'sp_delivery_te.pk3' \
    'supply.pk3' \
    'sw_goldrush_te.pk3' \
    'te_valhalla.pk3' \
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
