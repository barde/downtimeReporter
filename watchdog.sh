#!/bin/bash

#CONFIG PARAMETERS
if [ ! -f "./config" ] && [ -f "./config.demo" ] ; then
    echo "Please set own configuration from config.demo"
    exit
fi

source ./config

debug=true

function debugLog() {
    if [ "$debug" = true ] ; then
        echo $1
    fi
}

function debugCaller() {
    if [ "$debug" = true ] ; then
        echo Func call: ${FUNCNAME[1]}
    fi
}

function isPrimaryAPAvailable() {
    debugCaller
    return 1
    #return codes:
    #0=ok
    #1=no internet
    #2=no wifi ap
}

function isBackupAPAvailable() {
    debugCaller
    return 0
    #return codes:
    #0=ok
    #1=no internet
    #2=no wifi ap
}

function changeNetworkToBackupAP() {
    debugCaller
    return
}

function changeNetworkToPrimaryAP() {
    debugCaller
    return
}

function sendDowntimeRestoredMessage() {
    debugCaller
    sendQueueMessage "downtime Restored"
}

function sendDowntimeHappeningMessage() {
    debugCaller
    sendQueueMessage "downtime Happening"
    return
}

# parameter: log message
function sendQueueMessage() {
    debugCaller
    DATE_NOW=$(date -Ru | sed 's/\+0000/GMT/')
    AZ_VERSION="2018-03-28"
    AZ_STORAGE_URL="https://${AZ_STORAGE_NAME}.queue.core.windows.net"
    AZ_STORAGE_TARGET="${AZ_STORAGE_URL}/${AZ_STORAGE_QUEUE}/"
    LOG_MSG=$1

    curl -v -X POST -H "Conent-Type:application/json" -H "x-ms-date: ${DATE_NOW}" -H "x-ms-version: ${AZ_VERSION}" "${AZ_STORAGE_TARGET}messages?visibilitytimeout=30&timeout=30${AZ_SAS_TOKEN}" -d "${LOG_MSG}"
    return
}

#init state variables
wasDown=false

#do forever
while true
do
    isPrimaryAPAvailable
    primaryAPAvailable=$?

    # reset after successful reconnect after downtime
    if [ $primaryAPAvailable -eq 0 ] && [ wasDown = true ] ; then
        sendDowntimeRestoreMessage
        wasDown=false
    fi
    

    if [ $primaryAPAvailable -ne 0 ] ; then
        changeNetworkToBackupAP
        isBackupAPAvailable
        backupAPAvailable=$?

        if [ $backupAPAvailable -eq 0 ] ; then
            sendDowntimeHappeningMessage
        fi
        
        wasDown=true

        changeNetworkToPrimaryAP
    fi

    sleep 1m
done
