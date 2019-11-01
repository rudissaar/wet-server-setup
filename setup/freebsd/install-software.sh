#!/usr/bin/env sh

WET_UID='27960'
WET_GID='27960'
WET_DIR='/srv/wet'

# You need root permissions to run this script.
if [ "$(id -u)" != '0' ]; then
    echo '> You need to become root to run this script.'
    exit 1
fi

# Install packages.
pkg install -y \
    linux_base-c6 \
    unzip \
    wget

# Create group for WET Server.
pw groupadd \
    wet \
    -g "${WET_GID}" \
    2> /dev/null

# Create user for WET Server.
pw useradd \
    wet \
    -u "${WET_UID}" \
    -g "${WET_GID}" \
    -d "${WET_DIR}" \
    -c 'Wolfenstein Enemy Territory Server' \
    -s '/bin/sh' \
    2> /dev/null

if [ ! -f "${WET_DIR}" ]; then
    mkdir -p "${WET_DIR}"
fi

chown -R 'wet:wet' "${WET_DIR}"
chmod 2750 "${WET_DIR}"

# Enable Linux kernel module.
kldload linux
sysrc linux_enable="YES"

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

# Run installer.
"${INSTALLER}" \
    --target "${INSTALLER_PATH}" \
    --noexec \
    2> /dev/null

# Run setup script.
"${INSTALLER}/setup.sh" 2> /dev/null

cp "${INSTALLER_PATH}/bin/FreeBSD/x86/etded.x86" "${WET_DIR}"
cp -r "${INSTALLER_PATH}/etmain" "${WET_DIR}"
cp -r "${INSTALLER_PATH}/pb" "${WET_DIR}"

# Last correction for ownership and permissions.
chown -R 'wet:wet' "${WET_DIR}"
chmod -R o-rwx "${WET_DIR}"

# Cleanup.
rm -rf "${INSTALLER_PATH}"

echo '> Finished.'

