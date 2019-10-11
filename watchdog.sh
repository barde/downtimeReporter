#!/bin/bash

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
    return 1
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
    return
}

function sendDowntimeHappeningMessage() {
    debugCaller
    return
}

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
