#!/usr/bin/env bash

st_patch_linux () {
    local PATCHER_PATH="$1"
    local OUTPUT_DIR="$2"
    local ST_VERSION="$3"
    local ST_TARBALL_X64="sublime_text_build_${ST_VERSION}_x64.tar.xz"

    pushd "${OUTPUT_DIR}" || exit

    curl -O "https://download.sublimetext.com/${ST_TARBALL_X64}"

    tar xJf "${ST_TARBALL_X64}"
    mkdir -p "sublime_text/Data/"

    "${PATCHER_PATH}" \
        "$(pwd)/sublime_text/sublime_text" \
        "$(pwd)/sublime_text/Data/"

    rm -f "sublime_text/"*.bak
    tar cJf "patched_${ST_TARBALL_X64}" "sublime_text/"

    # clean up
    rm -rf "${ST_TARBALL_X64}" "sublime_text/"

    popd || exit
}
