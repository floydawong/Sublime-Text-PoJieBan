#!/usr/bin/env bash

st_patch_mac () {
    local PATCHER_PATH="$1"
    local OUTPUT_DIR="$2"
    local ST_VERSION="$3"
    local ST_TARBALL="sublime_text_build_${ST_VERSION}_mac.zip"

    pushd "${OUTPUT_DIR}" || exit

    curl -O "https://download.sublimetext.com/${ST_TARBALL}"

    unzip -o "${ST_TARBALL}"
    mkdir -p "Sublime Text.app/Contents/MacOS/Data/"

    "${PATCHER_PATH}" \
        "$(pwd)/Sublime Text.app/Contents/MacOS/Sublime Text" \
        "$(pwd)/Sublime Text.app/Contents/MacOS/Data/"

    rm -f "Sublime Text.app/Contents/MacOS/"*.bak

    codesign --remove-signature "Sublime Text.app"
    zip -9r "patched_${ST_TARBALL}" "Sublime Text.app/"
    mv -f "patched_${ST_TARBALL}" "${OUTPUT_DIR}"

    # clean up
    rm -rf "${ST_TARBALL}" "Sublime Text.app/"

    popd || exit
}
