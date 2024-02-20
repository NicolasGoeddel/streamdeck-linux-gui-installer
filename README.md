# About
This is just a simple script to install [streamdeck-linux-gui](https://github.com/streamdeck-linux-gui/streamdeck-linux-gui) inside a virtual environment in this directory.
It installs:
- all the python dependencies
- an application launcher
- the udev rules

# Installation
Just run `./setup.sh`.
If the udev rules are not yet installed on your system you will be prompted to enter your `sudo` password.

# Executing
You can skip the setup and just execute `./run.sh` which runs `setup.sh` implicitely.
Or you just use the application launcher with the name `Stream Deck UI` from Gnome.

# Uninstall
Just run `./uninstall.sh`.
