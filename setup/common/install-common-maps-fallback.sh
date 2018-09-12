#!/usr/bin/env sh

WET_DIR='/srv/wet'
MAPS_URL='http://legacy.murda.eu/downloads/wet/maps/'

if [ "$(id -u)" != '0' ]; then
    echo '> You need to become root to run this script.'
    exit 1
fi

if [ ! -d "${WET_DIR}" ] || [ ! -d "${WET_DIR}/etmain" ]; then
    echo "> Destination directory doesn't exist, terminating."
    exit 1
fi

MAP_0='adlernest.pk3'
MAP_1='braundorf_b4.pk3'
MAP_2='bremen_b2.pk3'
MAP_3='caen2.pk3'
MAP_4='et_beach.pk3'
MAP_5='et_ice.pk3'
MAP_6='frostbite.pk3'
MAP_7='karsiah_te2.pk3'
MAP_8='missile_b3.pk3'
MAP_9='reactor_final.pk3'
MAP_10='sp_delivery_te.pk3'
MAP_11='supply.pk3'
MAP_12='sw_battery.pk3'
MAP_13='sw_goldrush_te.pk3'
MAP_14='tc_base.pk3'
MAP_15='te_valhalla.pk3'
MAP_16='tournementdm2.pk3'

for NUM in $(seq 0 16)
do
    MAP_VAR="MAP_${NUM}"
    MAP="$(eval echo \$${MAP_VAR})"
    
    if [ ! -f "${WET_DIR}/etmain/${MAP}" ]; then
        wget "${MAPS_URL}${MAP}" -O "${WET_DIR}/etmain/${MAP}"
    fi
done

# Last correction for ownership and permissions.
chown -R 'wet:wet' "${WET_DIR}"
chmod -R o-rwx "${WET_DIR}"

echo '> Finished.'

