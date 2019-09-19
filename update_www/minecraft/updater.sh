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
GET_VER=$(getJSONVal "$(getJSONData "$VERSIONS" "latest")" "release")
GET_DATA=$(echo "$VERSIONS" | egrep -o "\"id\":\"$GET_VER\"[^}]*")
GET_URL=$(getJSONVal "$GET_DATA" "url")
GET_JSON=$(curl -s $GET_URL)
SERVER_FILE="minecraft_server_${GET_VER}.jar"
SERVER_FILE_SHA1=$(getJSONVal "$(getJSONData "$GET_JSON" "server")" "sha1")
SERVER_URL=$(getJSONVal "$(getJSONData "$GET_JSON" "server")" "url")        
LOCAL_FILE=$([[ -n $1 ]] && echo "$1" || echo "$SERVER_FILE")

if [ "$LATEST_VER" != "$(cat $VAR_A/version.tek)" ]; then
	  echo $GET_VER > $VAR_A/version.tek
	  wget -q -O $LOCAL_FILE $SERVER_URL
	  echo "$(date) - The latest version has been downloaded!" >> $VAR_A/logs/$LOGDATE-update.log
fi

if [ "$(sha1sum "$LOCAL_FILE" | awk '{print $1}')" != "$SERVER_FILE_SHA1" ]; then
	echo "$(date) - Checksum of downloaded file does not match!" >> $VAR_A/logs/$LOGDATE-update.log
	rm "$LOCAL_FILE"
fi

if [ -f $LOCAL_FILE ]; then
  mv $VAR_A/minecraft_server.jar $VAR_A/$LOGDATE_minecraft_server.jar
	mv "$LOCAL_FILE" $VAR_A/minecraft_server.jar
	echo "$(date) - The update was successful!" >> $VAR_A/logs/$LOGDATE-update.log
fi

echo "$(date) - Latest version: $GET_VER, Data request: $GET_DATA, Version URL: $GET_URL, Download URL: $SERVER_URL" >> $VAR_A/logs/$LOGDATE-update.log

exit 0
