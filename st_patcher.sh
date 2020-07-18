#!/usr/bin/env bash
# @see https://gist.github.com/n6333373/c15e8ae61f5e0421cf9091affb733312
# Usage: ./patch_sublime_text.sh [bin_path] [data_dir]

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# (optional) the path of the Sublime Text executable
# such as "C:\Program Files\Sublime Text\sublime_text.exe"
BIN_PATH="$1"

# (optional) the Data directory for non-portable mode
# such as "C:\Users\David\AppData\Roaming\Sublime Text"
DATA_DIR="$2"

# the license code to be used
LICENSE_CODE="$(cat <<-EOT
----- BEGIN LICENSE -----
TwitterInc
200 User License
EA7E-890007
1D77F72E 390CDD93 4DCBA022 FAF60790
61AA12C0 A37081C5 D0316412 4584D136
94D7F7D4 95BC8C1C 527DA828 560BB037
D1EDDD8C AE7B379F 50C9D69D B35179EF
2FE898C4 8E4277A8 555CE714 E1FB0E43
D5D52613 C3D12E98 BC49967F 7652EED2
9D2D2E61 67610860 6D338B72 5CF95C69
E36B85CC 84991F19 7575D828 470A92AB
------ END LICENSE ------
EOT
)"

patch_sublime_text_exe () {
    local BIN_PATH_USER="$1"

    local is_bin_path_found=0
    local bin_paths=(
        # user specified
        "${BIN_PATH_USER}"
        # portable mode (Windows)
        "./sublime_text.exe"
        "../sublime_text.exe"
        # portable mode (Linux, Mac)
        "./sublime_text"
        "../sublime_text"
    )

    for bin_path in "${bin_paths[@]}"; do
        if [ ! -f "${bin_path}" ] || [[ "${bin_path}" = "" ]]; then
            continue
        fi

        is_bin_path_found=1

        local bin_hex="${bin_path}.hex"

        echo "* patching executable: '${bin_path}'"

        xxd -ps "${bin_path}" | tr -d '\r\n' > "${bin_hex}"

        sed -i'' \
            $(: skip local revoked license check ) \
            -e 's/97940d/000000/g' \
            $(: replace "sublimetext.com" with "sublimetext_com" ) \
            $(: this will disable online license/update check ) \
            $(: for update check, see https://forum.sublimetext.com/t/28107 ) \
            -e 's/7375626c696d65746578742e636f6d/7375626c696d65746578745f636f6d/g' \
            "${bin_hex}"

        mv "${bin_path}" "${bin_path}.bak"
        xxd -r -ps "${bin_hex}" "${bin_path}"
        chmod a+x "${bin_path}"

        rm -f "${bin_hex}"

        echo "* patching executable... done"

        break
    done

    if [[ "${is_bin_path_found}" = "0" ]]; then
        echo "* cannot find the sublime_text binary..."
        exit 1
    fi
}

apply_license () {
    local DATA_DIR_USER="$1"
    local LICENSE_CODE="$2"

    local is_data_dir_found=0
    local data_dirs=(
        # user specified
        "${DATA_DIR_USER}"
        # portable mode
        "./Data/"
        "../Data/"
        # traditional (Windows)
        "${APPDATA}/Sublime Text/"
        "${APPDATA}/Sublime Text 3/"
        # traditional (Linux)
        "${HOME}/.config/sublime-text"
        "${HOME}/.config/sublime-text-3"
        # traditional (Mac)
        "${HOME}/Library/Application Support/Sublime Text"
        "${HOME}/Library/Application Support/Sublime Text 3"
    )

    for data_dir in "${data_dirs[@]}"; do
        if [ ! -d "${data_dir}" ] || [[ "${data_dir}" = "" ]]; then
            continue
        fi

        is_data_dir_found=1

        pushd "${data_dir}" || exit

        mkdir -p "Local/"
        echo "${LICENSE_CODE}" > "Local/License.sublime_license"
        echo "* license has been added to '${data_dir}'"

        popd || exit

        break
    done

    if [[ "${is_data_dir_found}" = "0" ]]; then
        echo "* cannot find the Data directory, fill the following license by yourself:"
        echo "${LICENSE_CODE}"
    fi
}


# ------------------ #
# let the work begin #
# ------------------ #

pushd "${SCRIPT_DIR}" || exit

patch_sublime_text_exe "${BIN_PATH}"
apply_license "${DATA_DIR}" "${LICENSE_CODE}"

popd || exit
