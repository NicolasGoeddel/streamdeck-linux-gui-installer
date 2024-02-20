#!/bin/bash

set -eu

source .common.sh

# Delete the application launcher
rm "${HOME}/.local/share/applications/${APP_MENU_FILENAME}.desktop"

# Delete the udev rules
sudo rm "${UDEV_TARGET_PATH}"

# Delete the virtual environment
rm -rf ".venv${VENV_SUFFIX}"

echo "${APP_TITLE} was uninstalled successfully."
