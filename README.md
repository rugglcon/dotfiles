# Dotfiles
This used to only be for my vim config, however it now contains all config files that will need to be transferred between installs, including scripts.

## Installation
To install on a new system, clone this repo then run `sudo -u $USER ./setup.sh`. For help, use the `-h` option.

## Dependencies
Since I've moved to use i3, there's quite a few new dependencies that weren't here before. There's so many that it wouldn't make sense to try and configure them all in the setup script, as some have packages in some distros and some not, and they are named differently per each distro with a package. So I'm just going to list them here:

* `i3-gaps` (https://github.com/Airblader/i3)
* `i3lock-color` (https://github.com/chrjguill/i3lock-color)
* `feh`
* `urxvt`
* `pywal` (https://github.com/dylanaraps/pywal)
* `i3-volume` (https://github.com/hastinbe/i3-volume)
* `light` (https://github.com/haikarainen/light)
* `Font Awesome` (https://github.com/FortAwesome/Font-Awesome)
* `playerctl`
* `gxmessage`
* `acpi`
* `rofi`

## Instructions for Arch (for future reference)
* follow installation guide on the wiki
* install dependencies listed here
* run the setup.sh script
* should be good to go
