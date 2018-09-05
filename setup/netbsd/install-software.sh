#!/usr/bin/env sh

WET_UID='27960'
WET_GID='27960'
WET_DIR='/srv/wet'

# You need root permissions to run this script.
if [ "$(id -u)" != '0' ]; then
    echo '> You need to become root to run this script.'
    exit 1
fi

[ -z "${PKG_PATH}" ]
if [ "${?}" = '0' ]; then
    MIRROR='http://cdn.NetBSD.org/pub/pkgsrc/packages/NetBSD/'
    PKG_PATH="${MIRROR}$(uname -p)/$(uname -r|cut -f '1 2' -d.|cut -f 1 -d_)/All"
    export PKG_PATH
fi

# Install packages.
pkg_add -v \
    suse32_base \
    sudo \
    ntp \
    unzip \
    dialog \
    wget

# Create group for WET Server.
groupadd \
    -g "${WET_GID}" \
    wet

# Create user for WET Server.
useradd \
    -u "${WET_UID}" \
    -g "${WET_GID}" \
    -d "${WET_DIR}" \
    -c 'Wolfenstein Enemy Territory Server' \
    -s '/bin/csh' \
    wet

if ! [ -f "${WET_DIR}" ]; then
    mkdir -p "${WET_DIR}"
fi

chown -R 'wet:wet' "${WET_DIR}"
chmod 2750 "${WET_DIR}"

if [ -z "${1}" ]; then
    WET_ZIP_URL='http://filebase.trackbase.net/et/full/et260b.x86_full.zip'
else
    WET_ZIP_URL="${1}"
fi

WET_ZIP_NAME="$(basename ${WET_ZIP_URL})"
WET_ZIP_PATH="/tmp/${WET_ZIP_NAME}"

if [ ! -f "${WET_ZIP_PATH}" ]; then
    wget "${WET_ZIP_URL}" -O "${WET_ZIP_PATH}"
fi

INSTALLER_PATH="/tmp/wet-install-$(date +%s)"
unzip "${WET_ZIP_PATH}" -d "${INSTALLER_PATH}"
INSTALLER="$(ls "${INSTALLER_PATH}/"*'.run' | head -n 1)"
chmod +x "${INSTALLER}"

# To fix known issue that happends if this directory doesn't exist.
if [ -d '/var/db' ]; then
    mkdir -p '/var/db'
fi

# Run installer.
"${INSTALLER}" \
    --target "${INSTALLER_PATH}" \
    --noexec \
    2> /dev/null

# Run setup script.
"${INSTALLER}/setup.sh" 2> /dev/null

cp "${INSTALLER_PATH}/bin/NetBSD/x86/etded.x86" "${WET_DIR}"
cp -r "${INSTALLER_PATH}/etmain" "${WET_DIR}"
cp -r "${INSTALLER_PATH}/pb" "${WET_DIR}"

# Last correction for ownership and permissions.
chown -R 'wet:wet' "${WET_DIR}"
chmod -R o-rwx "${WET_DIR}"

# Cleanup.
rm -rf "${INSTALLER_PATH}"

echo '> Finished.'

