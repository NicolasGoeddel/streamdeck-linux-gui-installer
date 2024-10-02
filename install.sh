#!/bin/bash

set -eu

if ! declare -p VENV_SUFFIX &>/dev/null; then
    source .common.sh
fi

# Step 2: Create virtual environment
python3 -m venv --prompt=stream-deck ".venv${VENV_SUFFIX}"

# Step 3: Activate virtual environment
source ".venv${VENV_SUFFIX}/bin/activate"

venv_path_absolute="$(realpath ".venv${VENV_SUFFIX}")"

# Step 4a: Install dependecies
sudo apt install libhidapi-libusb0 python3-pip '^libxcb.*-dev' libx11-xcb-dev libglu1-mesa-dev libxrender-dev libxi-dev libxkbcommon-dev libxkbcommon-x11-dev

# Step 4b: Install requirements (the app itself)
pip install -r requirements.txt

python_package_entrypoint="$(python -c "import ${PYTHON_PACKAGE_NAME} as _; print(_.__file__)")"
python_package_path="$(dirname "${python_package_entrypoint}")"

# Step 5: Install menu item
mkdir -p "${HOME}/.local/share/applications"
tee "${HOME}/.local/share/applications/${APP_MENU_FILENAME}.desktop" > /dev/null <<EOT
[Desktop Entry]
Version=X
Comment=${APP_MENU_COMMENT}
Terminal=false
Name=${APP_TITLE}./in
Type=Application
Categories=Development;
StartupNotify=true
Exec=${venv_path_absolute}/bin/streamdeck
Icon=${python_package_path}/logo.png
EOT

# Step 6: Install UDEV rules
udev_rules_content_remote="$(curl --silent "${UDEV_RULES_URL}")"
if [ -f "${UDEV_TARGET_PATH}" ]; then
    udev_rules_content_local="$(<"${UDEV_TARGET_PATH}")"
else
    udev_rules_content_local=""
fi
if [[ "${udev_rules_content_remote}" != "${udev_rules_content_local}" ]]; then
    echo "You need to enter your password to install the needed UDEV rules."
    sudo tee "${UDEV_TARGET_PATH}" >/dev/null <<< "${udev_rules_content_remote}"
    sudo udevadm trigger
fi

if (( ${#BASH_SOURCE[@]} == 1 )); then
    # Step 6: Deactivate virtual environment again if we were sourced from run.sh
    deactivate

    echo "Installation finished. Virtual environment created and packages installed."
    echo "./run.sh will start the program."
fi
