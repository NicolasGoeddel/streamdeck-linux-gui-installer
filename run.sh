#!/bin/bash

source .common.sh

if ! [ -d .venv ]; then
    source ./install.sh
else
    source ".venv${VENV_SUFFIX}/bin/activate"
fi

streamdeck
