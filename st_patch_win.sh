#!/usr/bin/env bash

st_patch_win () {
    local PATCHER_PATH="$1"
    local OUTPUT_DIR="$2"
    local ST_VERSION="$3"
    local ST_TARBALL_X64="sublime_text_build_${ST_VERSION}_x64.zip"

    pushd "${OUTPUT_DIR}" || exit

    curl -O "https://download.sublimetext.com/${ST_TARBALL_X64}"

    unzip -o "${ST_TARBALL_X64}" -d "sublime_text/"
    mkdir -p "sublime_text/Data/"

    "${PATCHER_PATH}" \
        "$(pwd)/sublime_text/sublime_text.exe" \
        "$(pwd)/sublime_text/Data/"

    pushd "sublime_text/" || exit

    rm -f *.bak
    zip -9r "patched_${ST_TARBALL_X64}" *
    mv -f "patched_${ST_TARBALL_X64}" "${OUTPUT_DIR}"

    popd || exit

    # clean up
    rm -rf "${ST_TARBALL_X64}" "sublime_text/"

    popd || exit
}
