#!/bin/sh

VAR_A=$1

DATE=$(date +"%Y.%m.%d %H:%M:%S")
LOGFILE=$(date +"%Y-%m-%d")

VERSIONS=$(curl -s https://launchermeta.mojang.com/mc/game/version_manifest.json)
GET_VER=$(getJSONVal "$(getJSONData "$VERSIONS" latest)" release)
GET_DATA=$(echo $VERSIONS | egrep -o "\"id\":\"${GET_VER}\"[^}]*")
GET_URL=$(getJSONVal "$GET_DATA" url)
GET_JSON=$(curl -s $GET_URL)
SERVER_FILE=minecraft_server_${GET_VER}.jar
SERVER_FILE_SHA1=$(getJSONVal "$(getJSONData "$GET_JSON" server)" sha1)
SERVER_URL=$(getJSONVal "$(getJSONData "$GET_JSON" server)" url)        
LOCAL_FILE=$([[ -n $1 ]] && echo "$1" || echo "$SERVER_FILE")

if [ "$LATEST_VER" != "$(cat $VAR_A/version.tek)" ]; then
	echo $GET_VER > $VAR_A/version.tek
	wget -q -O "${LOCAL_FILE}" ${SERVER_URL}
	echo "$DATE - The latest version has been downloaded!" >> $VAR_A/logs/$LOGFILE-update.log
	echo "$DATE - The latest version has been downloaded!"
fi

if [ "$(sha1sum "${LOCAL_FILE}" | awk '{print $1}')" != "${SERVER_FILE_SHA1}" ]; then
	echo "Checksum of downloaded file does not match!" 
	rm "$LOCAL_FILE"
fi

if [ -f $LOCAL_FILE ]; then
	mv "$LOCAL_FILE" $VAR_A/minecraft_server.jar
	echo "$DATE - The update was successful!" >> $VAR_A/logs/$LOGFILE-update.log
	echo "$DATE - The update was successful!"
fi

# DEBUG CHECK START
echo "Debug:"
echo "$DATE - Latest version: $GET_VER"
echo "$DATE - Data request: $GET_DATA"
echo "$DATE - Version URL: $GET_URL"
echo "$DATE - Download URL: $SERVER_URL"
# DEBUG CHECK END

exit 0