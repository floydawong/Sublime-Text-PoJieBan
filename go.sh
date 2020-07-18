#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPO_DIR="${SCRIPT_DIR}"

OUTPUT_DIR="${REPO_DIR}/output/"
PATCHER_PATH="${REPO_DIR}/st_patcher.sh"

# win, linux, mac
PLATFORM="$1"

rm -rf "${OUTPUT_DIR}" && mkdir -p "${OUTPUT_DIR}"

# shellcheck disable=SC1091
source "st_variables.sh"

pushd "${REPO_DIR}" || exit

if [[ "${PLATFORM}" = "" ]]; then
    PLATFORM="all"
fi

if [[ "${PLATFORM}" = "all" ]] || [[ "${PLATFORM}" = "win" ]]; then
    # shellcheck disable=SC1091
    source "st_patch_win.sh"
    st_patch_win   "${PATCHER_PATH}" "${OUTPUT_DIR}" "${ST_VERSION}"
fi

if [[ "${PLATFORM}" = "all" ]] || [[ "${PLATFORM}" = "linux" ]]; then
    # shellcheck disable=SC1091
    source "st_patch_linux.sh"
    st_patch_linux   "${PATCHER_PATH}" "${OUTPUT_DIR}" "${ST_VERSION}"
fi

if [[ "${PLATFORM}" = "all" ]] || [[ "${PLATFORM}" = "mac" ]]; then
    # shellcheck disable=SC1091
    source "st_patch_mac.sh"
    st_patch_mac   "${PATCHER_PATH}" "${OUTPUT_DIR}" "${ST_VERSION}"
fi

popd || exit
