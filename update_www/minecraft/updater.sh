#!/bin/bash

VAR_A=$1
LOGDATE=$(date +"%Y-%m-%d")
LOGFILE=$(date +"%Y-%m")
LOGDIR="logs"

readonly MINECRAFT_DIR=$VAR_A
readonly MINECRAFT_SERVER_LATEST_VER=$( curl https://launchermeta.mojang.com/mc/game/version_manifest.json|jq -r '."latest"."release"' )
readonly MINECRAFT_SERVER_LATEST_MANIFEST_URL=$( curl https://launchermeta.mojang.com/mc/game/version_manifest.json | jq -r ".\"versions\"[] | select (.\"id\"==\"${MINECRAFT_SERVER_LATEST_VER}\") | .\"url\" " )
readonly MINECRAFT_SERVER_LATEST_JAR_URL=$( curl "${MINECRAFT_SERVER_LATEST_MANIFEST_URL}" | jq -r ".\"downloads\".\"server\".\"url\"" )
readonly MINECRAFT_SERVER_LATEST_JAR_SHA1=$( curl "${MINECRAFT_SERVER_LATEST_MANIFEST_URL}" | jq -r ".\"downloads\".\"server\".\"sha1\"" )
readonly SERVERFILE="minecraft_server.${MINECRAFT_SERVER_LATEST_VER}.jar"
# readonly LOCALFILE=$([[ -n $1 ]] && echo "$1" || echo "$SERVERFILE")

# readonly MINECRAFT_SERVER_CURRENT_INSTALLED_VER=$( ls ${MINECRAFT_DIR}/*.jar | cut -d '/' -f4 | sed -e "s/minecraft_server\.//" -e "s/\.jar//" )
# rm ${MINECRAFT_DIR}/minecraft_server.${MINECRAFT_SERVER_CURRENT_INSTALLED_VER}.jar

if [ "$MINECRAFT_SERVER_LATEST_VER" != "$(cat $VAR_A/version.tek)" ]; then
	wget ${MINECRAFT_SERVER_LATEST_JAR_URL} -O ${MINECRAFT_DIR}/minecraft_server.${MINECRAFT_SERVER_LATEST_VER}.jar
	echo "$(date) - INFO: The latest server version has been downloaded!" >> $VAR_A/$LOGDIR/$LOGFILE-update.log

	if [ "$(sha1sum $SERVERFILE | awk '{print $1}')" != "$MINECRAFT_SERVER_LATEST_JAR_SHA1" ]; then
        	echo "$(date) - ERROR: Checksum of downloaded file does not match! Aborting gameserver update!" >> $VAR_A/$LOGDIR/$LOGFILE-update.log
		rm "$SERVERFILE"
		exit 0
	else
		echo "$(date) - INFO: Checksum of downloaded file ok!" >> $VAR_A/$LOGDIR/$LOGFILE-update.log
	fi

	mv ${MINECRAFT_DIR}/minecraft_server.jar ${MINECRAFT_DIR}/${LOGDATE}_minecraft_server.jar
	mv ${SERVERFILE} ${MINECRAFT_DIR}/minecraft_server.jar
	echo "$MINECRAFT_SERVER_LATEST_VER" > version.tek   
	echo "$(date) - INFO: version.tek has been modified to latest release version!" >> $VAR_A/$LOGDIR/$LOGFILE-update.log
	echo "$(date) - INFO: The server was successful updated to version $MINECRAFT_SERVER_LATEST_VER!" >> $VAR_A/$LOGDIR/$LOGFILE-update.log
	echo "$(date) - DEBUG: Latest version=$MINECRAFT_SERVER_LATEST_VER" >> $VAR_A/$LOGDIR/$LOGFILE-update.log
	echo "$(date) - DEBUG: Manifest url=$MINECRAFT_SERVER_LATEST_MANIFEST_URL" >> $VAR_A/$LOGDIR/$LOGFILE-update.log
	echo "$(date) - DEBUG: Server jar url=$MINECRAFT_SERVER_LATEST_JAR_URL" >> $VAR_A/$LOGDIR/$LOGFILE-update.log
	echo "$(date) - DEBUG: Server file name=$SERVERFILE" >> $VAR_A/$LOGDIR/$LOGFILE-update.log
	echo "$(date) - DEBUG: SHA1 Checksum=$MINECRAFT_SERVER_LATEST_JAR_SHA1" >> $VAR_A/$LOGDIR/$LOGFILE-update.log
else
	echo "$(date) - INFO: The latest version $MINECRAFT_SERVER_LATEST_VER is already installed! No need to update!" >> $VAR_A/$LOGDIR/$LOGFILE-update.log

fi


exit 0
