#!/usr/bin/env bash
# Script that installs Wolfenstein Enemy Territory software on the current system.

WET_USER='wet'
WET_UID='27960'
WET_GID='27960'
WET_DIR="/srv/${WET_USER}"

# You need root permissions to run this script.
if [[ "${UID}" != '0' ]]; then
    echo '> You need to become root to run this script.'
    echo '> Aborting.'
    exit 1
fi

# Function that checks if required binary exists and installs it if necessary.
ENSURE_PACKAGE () {
    REQUIRED_BINARY=$(basename "${1}")
    REPO_PACKAGES="${*:2}"

    if [[ "${REQUIRED_BINARY}" != '-' ]]; then
        [[ -n "${REPO_PACKAGES}" ]] || REPO_PACKAGES="${REQUIRED_BINARY}"

        if command -v "${REQUIRED_BINARY}" 1> /dev/null; then
            REPO_PACKAGES=''
        fi
    fi

    [[ -n "${REPO_PACKAGES}" ]] || return

    if [[ "${REPO_REFRESHED}" == '0' ]]; then
        echo '> Refreshing package repository.'
        dnf check-update 1> /dev/null
        REPO_REFRESHED=1
    fi

    for REPO_PACKAGE in ${REPO_PACKAGES}
    do
        dnf install -y "${REPO_PACKAGE}"
    done
}

# Variable that keeps track if repository is already refreshed.
REPO_REFRESHED=0

# Install packages.
ENSURE_PACKAGE '-' 'glibc.i686' 'libstdc++.i686'
ENSURE_PACKAGE 'linux32' 'util-linux'
ENSURE_PACKAGE 'findutils'
ENSURE_PACKAGE 'wget'
ENSURE_PACKAGE 'unzip'
ENSURE_PACKAGE 'tar'

# Create group for WET Server.
groupadd \
    --gid "${WET_GID}" \
    "${WET_USER}"

# Create user for WET Server.
useradd \
    --uid "${WET_UID}" \
    --gid "${WET_GID}" \
    --home-dir "${WET_DIR}" \
    --comment 'Wolfenstein Enemy Territory Server' \
    --shell '/bin/bash' \
    "${WET_USER}"

[[ -d "${WET_DIR}" ]] || mkdir -p "${WET_DIR}"
chown -R "${WET_USER}:${WET_USER}" "${WET_DIR}"
chmod 2750 "${WET_DIR}"

if [[ -z "${1}" ]]; then
    WET_ZIP_URL='http://filebase.trackbase.net/et/full/et260b.x86_full.zip'
else
    WET_ZIP_URL="${1}"
fi

WET_ZIP_NAME=$(basename "${WET_ZIP_URL}")
WET_ZIP_PATH="/tmp/${WET_ZIP_NAME}"

# Download archive.
[[ -f "${WET_ZIP_PATH}" ]] || wget "${WET_ZIP_URL}" -O "${WET_ZIP_PATH}"

INSTALLER_PATH="/tmp/wet-install-$(date +%s)"
unzip "${WET_ZIP_PATH}" -d "${INSTALLER_PATH}"
INSTALLER=$(find "${INSTALLER_PATH}" -name '*.run' | head -n 1)
chmod +x "${INSTALLER}"

# To fix known issue that happens if this directory doesn't exist.
[[ -d '/var/db' ]] || mkdir -p '/var/db'

# Run installer.
"${INSTALLER}" \
    --target "${INSTALLER_PATH}" \
    --noexec \
    2> /dev/null

# Run setup script.
"${INSTALLER}/setup.sh" 2> /dev/null

cp "${INSTALLER_PATH}/bin/Linux/x86/etded.x86" "${WET_DIR}"
cp -r "${INSTALLER_PATH}/etmain" "${WET_DIR}"
cp -r "${INSTALLER_PATH}/pb" "${WET_DIR}"

# Last correction for ownership and permissions.
chown -R "${WET_USER}:${WET_USER}" "${WET_DIR}"
chmod -R o-rwx "${WET_DIR}"

# Cleanup.
rm -rf "${INSTALLER_PATH}"

# Let user know that script has finished its job.
echo '> Finished.'

