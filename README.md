# Wolfenstein: Enemy Territory Server Setup

<img src="https://img.shields.io/badge/wet-2.60b-blue.png" alt="Wolfenstein: Enemy Territory 2.60b" title="Wolfenstein: Enemy Territory 2.60b"/>&nbsp;<a href="LICENSE" title="Licence"><img src="https://img.shields.io/badge/license-MIT-green.png" alt="Licence"/></a>

This repository stores scripts that make setting up Wolfenstein: Enemy Territory 2.60b server much easier than it normally is.

## Guides

Here is a list of available guides to help you with your setup, you should keep in mind that root permissions are required to run scripts.

* [ETPro Match Server](#etpro-match-server)

### ETPro Match Server

If you would like to set up a ETPro match server, follow given instruction for your distribution of choice:

#### Debian GNU/Linux

<img src="https://img.shields.io/badge/debian-9-green.png" alt="Debian 9" title="Tested">

After downloading/cloning repository navigate to directory `setup/debian`.

Then execute following scripts with `bash` shell in given order:

1. [install-software.sh](setup/debian/install-software.sh)
2. [install-common-maps.sh](setup/common/install-common-maps.sh)
3. [etpro-install.sh](setup/debian/etpro-install.sh)
4. [etpro-conf-global.sh](setup/debian/etpro-conf-global.sh)

##### Systemd Integration

You also have option to integrate server with `systemd`, it provides you with functionalities like restarting, starting or stopping server and also gives you option to start server once host machine boots up.

To integrate your server with systemd execute following script:

* [integrate-systemd.sh](setup/debian/integrate-systemd.sh)

After integration you can start your server by executing command:

`systemctl start wet`

If you would like your server to start automatically when host machine boots up enter command:

`systemctl enable wet`

#### FreeBSD

<img src="https://img.shields.io/badge/freebsd-12-green.png" alt="FreeBSD 12" title="Tested">

After downloading/cloning repository navigate to directory `setup/freebsd`.

Then execute following scripts with `sh` shell in given order:

1. [install-software.sh](setup/freebsd/install-software.sh)
2. [install-common-maps.sh](setup/common/install-common-maps-fallback.sh)
3. [etpro-install.sh](setup/common/etpro-install-fallback.sh)
4. [etpro-conf-global.sh](setup/common/etpro-conf-global-fallback.sh)

