#!/usr/bin/env bash

set -o nounset
set -o pipefail
set -o errexit
#set -o xtrace

root_directory=$(dirname $(dirname ${BASH_SOURCE[0]}))
kpackagetool6 -t Plasma/Wallpaper -u ${root_directory} || kpackagetool6 -t Plasma/Wallpaper -i ${root_directory}
