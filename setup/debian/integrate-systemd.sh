#!/usr/bin/env bash

RELATIVE_PATH=$(dirname ${0})

if [[ "${UID}" != '0' ]]; then
    echo '> You need to become root to run this script.'
    exit 1
fi

if [[ ! -d '/lib/local/systemd/system' ]]; then
    mkdir -p '/lib/local/systemd/system'
fi

if [[ ! -f '/lib/local/systemd/system/wet.service' ]]; then
    cp "${RELATIVE_PATH}/../../systemd/wet.service" '/lib/local/systemd/system/wet.service'
fi

ln -sf '/lib/local/systemd/system/wet.service' '/etc/systemd/system/wet.service'
systemctl daemon-reload

echo '> Finished.'
