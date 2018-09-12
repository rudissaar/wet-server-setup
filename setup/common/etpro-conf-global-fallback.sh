#!/usr/bin/env sh

WET_UID='27960'
WET_GID='27960'
WET_DIR='/srv/wet'

RELATIVE_PATH=$(dirname ${0})

# You need root permissions to run this script.
if [ "$(id -u)" != '0' ]; then
    echo '> You need to become root to run this script.'
    exit 1
fi

if [ -z "${1}" ]; then
    ETPRO_CONF_ZIP_URL='https://antman.info/wolf/etpro/download.php?serverconfigs/globalconfigsv1_3.zip'
else
    ETPRO_CONF_ZIP_URL="${1}"
fi

ETPRO_CONF_ZIP_NAME="$(basename ${ETPRO_CONF_ZIP_URL})"
ETPRO_CONF_ZIP_PATH="/tmp/${ETPRO_CONF_ZIP_NAME}"

if [ ! -f "${ETPRO_CONF_ZIP_PATH}" ]; then
    wget "${ETPRO_CONF_ZIP_URL}" -O "${ETPRO_CONF_ZIP_PATH}"
fi

TMP_PATH="/tmp/etpro-conf-global-$(date +%s)"
unzip "${ETPRO_CONF_ZIP_PATH}" -d "${TMP_PATH}"

cp -r "${TMP_PATH}/"* "${WET_DIR}/etpro"

# Cleanup.
rm -rf "${TMP_PATH}"

if [ ! -d "${WET_DIR}/etmain/serverconfigs" ]; then
    mkdir -p "${WET_DIR}/etmain/serverconfigs"
fi

if [ ! -f "${WET_DIR}/etmain/serverconfigs/etpro.cfg" ]; then
    cp "${RELATIVE_PATH}/../../configs/etpro.cfg" "${WET_DIR}/etmain/serverconfigs/"
fi

cat > "${WET_DIR}/run-etpro.sh" <<EOL
#!/usr/bin/env sh

exec ${WET_DIR}/etded.x86 \\
    +set dedicated 2 \\
    +set net_port 27960 \\
    +set fs_game etpro \\
    +set fs_homepath servers/27960 \\
    +set sv_punkbuster 0 \\
    +map te_valhalla \\
    +exec serverconfigs/etpro.cfg

EOL

chmod +x "${WET_DIR}/run-etpro.sh"
ln -sf "${WET_DIR}/run-etpro.sh" "${WET_DIR}/run.sh"

# Last correction for ownership and permissions.
chown -R 'wet:wet' "${WET_DIR}"
chmod -R o-rwx "${WET_DIR}"

echo '> Finished.'

