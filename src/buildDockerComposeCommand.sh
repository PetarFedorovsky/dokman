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

    if [[ ! -f ${configFile} ]]; then
        error "Config file $(foregroundColor ${configFile} "yellow") not found. Aborting!"
        exit 1
    fi

    while read line
    do
        # if empty line or commented out, skip
        if [ -z $(echo ${line} | grep -v "^\(\s\+\)\?#" | grep -v "^\(\s\+\)\?$") ]; then
            continue
        fi

        local pathToYml="${path}/${line}"
        if [ -r ${pathToYml} ]; then
            command="${command} -f \"${pathToYml}\""
        fi
    done < ${configFile}

    echo "${command} ${arguments}"
}
