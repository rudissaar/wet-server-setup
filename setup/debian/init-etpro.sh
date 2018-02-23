#!/usr/bin/env bash

WET_DIR='/srv/wet'

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
