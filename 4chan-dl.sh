#!/usr/bin/env bash

set -eu

function fetch() {
    wget -O - -q "${@}"
    sleep 1.5;
}

function get_boards() {
    fetch "https://a.4cdn.org/boards.json"
}

function show_boards() {
    jq -r '.boards[] | ("      " + .board)[-6:] + ": " + .title'
}

function get_catalog() {
    local -r BOARD=${1}; shift

    fetch "https://a.4cdn.org/${BOARD}/catalog.json"
}

function show_catalog() {
    jq -r '.[].threads|.[]|select( .sticky == null) | (.no|tostring) + ": " + if .sub then .sub else .semantic_url end + " (" + (.images|tostring) + ")"'
}

function get_thread() {
    local -r BOARD=${1}; shift
    local -r NO=${1}; shift

    fetch "https://a.4cdn.org/${BOARD}/thread/${NO}.json"
}

function thread_images() {
    local -r BOARD=${1}; shift
    local -r NO=${1}; shift

    jq -r '.posts[] |select( has("tim") and has("ext")) | "https://i.4cdn.org/'"${BOARD}"'/" + (.tim|tostring) + .ext'
}

function download_thread() {
    local -r BOARD=${1}; shift
    local -r NO=${1}; shift

    local -r dir=${BOARD}/${NO}

    mkdir -p "${dir}"

    get_thread "${BOARD}" "${NO}" \
    | thread_images "${BOARD}" "${NO}" \
    | xargs --no-run-if-empty wget --no-clobber --directory-prefix="${dir}" --wait=2
}

# wget -O - -q "https://a.4cdn.org/${BOARD}/catalog.json" \
# | jq -r '.[].threads|.[]|select( .sticky == null and has("tim") and .ext == ".jpg") | "https://i.4cdn.org/'"${BOARD}"'/" + (.tim|tostring) + .ext'


function main() {
    if [[ ${#} -eq 0 ]]; then
        get_boards \
        | show_boards
    elif [[ ${#} -eq 1 ]]; then
        get_catalog "${1}" \
        | show_catalog
    elif [[ ${#} -eq 2 ]]; then
        download_thread "${1}" "${2}"
    else
        echo "use: prog BOARD [THREAD]"
    fi
}

main "${@}"
