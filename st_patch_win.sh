#!/usr/bin/env bash

st_patch_win () {
    local PATCHER_PATH="$1"
    local OUTPUT_DIR="$2"
    local ST_VERSION="$3"
    local ST_TARBALL_X64="sublime_text_build_${ST_VERSION}_x64.zip"
    local ST_TARBALL_X64_OUTPUT="sublime_text_build_${ST_VERSION}_x64.7z"

    pushd "${OUTPUT_DIR}" || exit

    curl -O "https://download.sublimetext.com/${ST_TARBALL_X64}"

    unzip -o "${ST_TARBALL_X64}" -d "sublime_text/"
    mkdir -p "sublime_text/Data/"

    "${PATCHER_PATH}" \
        "$(pwd)/sublime_text/sublime_text.exe" \
        "$(pwd)/sublime_text/Data/"

    rm -f "sublime_text/"*.bak
    7za a -t7z -m0=lzma2 -mx=9 -mfb=64 -md=1024m -ms=on \
        "patched_${ST_TARBALL_X64_OUTPUT}" \
        "sublime_text/"

    # clean up
    rm -rf "${ST_TARBALL_X64}" "sublime_text/"

    popd || exit
}
