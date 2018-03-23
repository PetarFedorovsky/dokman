#!/usr/bin/env bash

###
 # Builds docker compose command from config file
 #
 # @param1 Path to env file
 # @param2 Path to compose files
 # @param3... Arguments that are passed to docker-compose command
###
function buildDockerComposeCommand
{
    local configFile=${1}
    local path=${2}
    local arguments=${*:3}

    local command='docker-compose'

    local yamls=()

    if [ ! -f "${configFile}" ]; then
        error "Config file $(foregroundColor "${configFile}" "yellow") not found. Aborting!"
        exit 1
    fi

    while read -r line
    do
        # if empty line or commented out, skip
        if ! echo "${line}" | grep -v "^\(\s\+\)\?#" | grep -q -v "^\(\s\+\)\?$" ; then
            continue
        fi

        local pathToYml="${path}/${line}"
        if [ -r "${pathToYml}" ]; then
            yamls+=("-f ${pathToYml}")
        fi
    done < "${configFile}"

    if [ ${#yamls[@]} -eq 0 ]; then
        error "No docker-compose yaml files detected in environment file $(foregroundColor "${configFile}" "yellow")"
        exit 1
    fi

    echo "${command} ${yamls[*]} ${arguments}"
}
