#!/usr/bin/env bash
# Script that downloads ETpro 3.2.6 mod for Wolfenstein Enemy Territory from internet.

WET_USER='wet'
WET_UID='27960'
WET_GID='27960'
WET_DIR="/srv/${WET_USER}"

if [[ "${UID}" != '0' ]]; then
    echo '> You need to become root to run this script.'
    echo '> Aborting.'
    exit 1
fi

if [[ -z "${1}" ]]; then
    ETPRO_ZIP_URL='https://antman.info/wolf/etpro/download.php?etpro-3_2_6.zip'
else
    ETPRO_ZIP_URL="${1}"
fi

ETPRO_ZIP_NAME="$(basename ${ETPRO_ZIP_URL})"
ETPRO_ZIP_PATH="/tmp/${ETPRO_ZIP_NAME}"

if [[ ! -f "${ETPRO_ZIP_PATH}" ]]; then
    wget "${ETPRO_ZIP_URL}" -O "${ETPRO_ZIP_PATH}"
fi

TMP_PATH="/tmp/etpro-init-$(date +%s)"
unzip "${ETPRO_ZIP_PATH}" -d "${TMP_PATH}"

if [[ -d "${WET_DIR}/etpro" ]]; then
    mkdir -p "${WET_DIR}/etpro"
fi

mv "${TMP_PATH}/"* "${WET_DIR}/etpro/"

# Last correction for ownership and permissions.
chown -R "${WET_USER}:${WET_USER}" "${WET_DIR}"
chmod -R o-rwx "${WET_DIR}"

# Cleanup.
rm -rf "${TMP_PATH}"

# Let user know that script has finished its job.
echo '> Finished.'

