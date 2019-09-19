#!/bin/bash

# TekBase - server control panel
# Copyright since 2005 TekLab
# Christian Frankenstein
# Website: teklab.de
#          teklab.net

VAR_A=$1

LOGDATE=$(date +"%Y-%m-%d")

function getJSONData {
    echo $1 | egrep -o "\"$2\": ?[^\}]*(\}|\")" | sed "s/\"$2\"://"
}

function getJSONVal {
    echo $1 | egrep -o "\"$2\": ?\"[^\"]*" | sed "s/\"$2\"://" | tr -d '{}" '
}


VERSIONS=$(curl -s https://launchermeta.mojang.com/mc/game/version_manifest.json)
GETVER=$(getJSONVal "$(getJSONData "$VERSIONS" "latest")" "release")
GETDATA=$(echo "$VERSIONS" | egrep -o "\"id\":\"$GETVER\"[^}]*")
GETURL=$(getJSONVal "$GETDATA" "url")
GETJSON=$(curl -s $GETURL)
SERVERFILE="minecraft_server_${GETVER}.jar"
SERVERFILESHA1=$(getJSONVal "$(getJSONData "$GETJSON" "server")" "sha1")
SERVERURL=$(getJSONVal "$(getJSONData "$GETJSON" "server")" "url")        
LOCALFILE=$([[ -n $1 ]] && echo "$1" || echo "$SERVERFILE")

if [ "$LATESTVER" != "$(cat $VAR_A/version.tek)" ]; then
    echo $GETVER > $VAR_A/version.tek
    wget -q -O $LOCALFILE $SERVERURL
    echo "$(date) - INFO: The latest version has been downloaded!" >> $VAR_A/logs/$LOGDATE-update.log

    if [ "$(sha1sum $LOCALFILE | awk '{print $1}')" != "$SERVERFILESHA1" ]; then
        echo "$(date) - Checksum of downloaded file does not match!" >> $VAR_A/logs/$LOGDATE-update.log
        rm "$LOCALFILE"
    fi

    if [ -f $LOCAL_FILE ]; then
        mv $VAR_A/minecraft_server.jar $VAR_A/${LOGDATE}_minecraft_server.jar
        mv "$LOCALFILE" $VAR_A/minecraft_server.jar
        echo "$(date) - INFO: The update was successful!" >> $VAR_A/logs/$LOGDATE-update.log
    fi
else
	echo "$(date) - INFO: The latest version is already installed!" >> $LOGDIR/$LOGFILE-update.log
fi

echo "$(date) - DEBUG" >> $VAR_A/logs/$LOGDATE-update.log
echo "Latest version=$GETVER" >> $VAR_A/logs/$LOGDATE-update.log
echo "Data request=$GETDATA" >> $VAR_A/logs/$LOGDATE-update.log
echo "Version URL=$GETURL" >> $VAR_A/logs/$LOGDATE-update.log
echo "Download URL=$SERVERURL" >> $VAR_A/logs/$LOGDATE-update.log


exit 0
