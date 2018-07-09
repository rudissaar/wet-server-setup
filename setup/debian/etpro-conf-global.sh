#!/usr/bin/env bash

WET_UID='27960'
WET_GID='27960'
WET_DIR='/srv/wet'

if [[ "${UID}" != '0' ]]; then
    echo '> You need to become root to run this script.'
    exit 1
fi

if [[ -z "${1}" ]]; then
    ETPRO_CONF_ZIP_URL='https://antman.info/wolf/etpro/download.php?serverconfigs/globalconfigsv1_3.zip'
else
    ETPRO_CONF_ZIP_URL="${1}"
fi

ETPRO_CONF_ZIP_NAME="$(basename ${ETPRO_CONF_ZIP_URL})"
ETPRO_CONF_ZIP_PATH="/tmp/${ETPRO_CONF_ZIP_NAME}"

if [[ ! -f "${ETPRO_CONF_ZIP_PATH}" ]]; then
    wget "${ETPRO_CONF_ZIP_URL}" -O "${ETPRO_CONF_ZIP_PATH}"
fi

TMP_PATH="/tmp/etpro-conf-global-$(date +%s)"
unzip "${ETPRO_CONF_ZIP_PATH}" -d "${TMP_PATH}"

cp -r "${TMP_PATH}/"* "${WET_DIR}/"

# Cleanup.
rm -rf "${TMP_PATH}"

cat > "${WET_DIR}/run-etpro.sh" <<EOL
#!/usr/bin/env bash
EOL

# Last correction for ownership and permissions.
chown -R 'wet:wet' "${WET_DIR}"
chmod -R o-rwx "${WET_DIR}"

echo '> Finished.'

