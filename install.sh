#!/bin/bash -x
# =============================================================================
# Preamble
# =============================================================================
set -e
MAIN_DIR="$(dirname "$BASH_SOURCE")"
cd "$MAIN_DIR"
SCRIPTDIR="$(pwd -P)"
cd - >/dev/null
# =============================================================================

# Install script for sys-oled
source "$SCRIPTDIR"/tools/env.sh

if [ "$(id -u)" != "0" ]; then
	echo "This script must be run as root!"
	exit 1
fi

# echo "Installing Dependencies"
# apt-get update

# if [[ "$(lsb_release -cs)" == "jammy" || "$(lsb_release -cs)" == "kinetic"  || "$(lsb_release -cs)" == "lunar"  || "$(lsb_release -cs)" == "bookworm"  || "$(lsb_release -cs)" == "trixie" || "$(lsb_release -cs)" == "sid" ]]; then
# 	echo "$(lsb_release -cs); use Ubuntu-packaged Python deps."
# 	apt-get install -y ${RUNTIME_DEPS}
# else
# 	echo "Not jammy, installing build deps, then using pip for python stuff. This is gonna take a while."
# 	apt-get install -y $BUILD_DEPS
# 	# luma.oled depends on this thing, but released non-alpha version does not build under gcc10
#         echo "Creating the venv"
#         python3 -m venv "$VENV_PATH"
#         source "$VENV_PATH"/bin/activate
#         python3 -m pip install --upgrade pip
# 	echo "Installing GPIO library dependency in pip..."
# 	pip3 install RPi.GPIO==0.7.1a4

# 	echo "Installing luma.oled library"
# 	pip3 install --upgrade luma.oled

#         pip3 install -r "$SCRIPTDIR"/requirements.txt
# fi

echo "Installing sys-oled files"
cp -fv "$SCRIPTDIR"/etc/sys-oled.conf /etc
cp -frv "$SCRIPTDIR"/bin "$INSTALL_PATH"
cp -frv "$SCRIPTDIR"/share "$INSTALL_PATH"
cp -frv "$SCRIPTDIR"/system "$SYSTEMD_PATH"
cp -frv "$SCRIPTDIR"/tools/* "$TOOLS_PATH"/

echo "Installing drive-temp-guard (cron + login notice)"
chmod 755 "$INSTALL_PATH"/bin/drive-temp-guard
install -m 644 -o root -g root "$SCRIPTDIR"/etc/cron.d/drive-temp-guard /etc/cron.d/drive-temp-guard
install -m 755 -o root -g root "$SCRIPTDIR"/etc/update-motd.d/99-thermal-shutdown /etc/update-motd.d/99-thermal-shutdown

echo "Enabling sys-oled at startup"
systemctl daemon-reload
systemctl enable sys-oled.service

echo "Restarting service..."
systemctl restart sys-oled.service
