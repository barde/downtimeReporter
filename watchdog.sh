#!/bin/bash

function isPrimaryAPAvailable() {
    return 0;
    #return codes:
    #0=ok
    #1=no internet
    #2=no router
}

function isBackupAPAvailable() {
    return 0
    #return codes:
    #0=ok
    #1=no internet
    #2=no router
}

function changeNetworkToBackupAP() {
    return
}

function changeNetworkToPrimaryAP() {
    return
}

function sendDowntimeRestoredMessage() {
    return
}

function sendDowntimeHappeningMessage() {
    return
}

wasDown=false

#do forever
while true
do
    isPrimaryAPAvailable
    primaryAPAvailable=$?

    # reset after successful reconnect after downtime
    if [ $primaryAPAvailable -eq 0 ] && [ wasDown = true ]
        then
            sendDowntimeRestoreMessage
            wasDown=false
    fi
    

    if [ $primaryAPAvailable -ne 0 ]
        then
            changeNetworkToBackupAP
            isBackupAPAvailable
            backupAPAvailable=$?

            if [ backupAPAvailable -eq 0 ]
                then
                    sendDowntimeHappeningMessage
            fi
        
            wasDown=true

            changeNetworkToPrimaryAP
    fi

    sleep 1m
done
