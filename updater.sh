#!/bin/bash

VAR_A=$1
VAR_B=$2
VAR_C=$3
VAR_D=$4

DATE=$(date +"%Y.%m.%d %H:%M:%S")
LOGFILE=$(date +"%Y-%m-%d")
LOGDIR="logs"

if [ ! -d "$LOGDIR" ]; then
	mkdir $LOGDIR
	chmod 755 $LOGDIR    
	echo "$DATE - The logs folder has just been created!" >> $LOGDIR/$LOGFILE-update.log
	echo "$DATE - The logs folder has just been created!"
fi

if [ ! -f "$VERSION" ]; then
	touch $VERSION
	echo "0" > version.tek   
	echo "$DATE - File version.tek has just been created!" >> $LOGDIR/$LOGFILE-update.log
	echo "$DATE - File version.tek has just been created!"
fi

function getJSONData {
	echo $1 | egrep -o "\"$2\": ?[^\}]*(\}|\")" | sed "s/\"$2\"://"
}

function getJSONVal {
	echo $1 | egrep -o "\"$2\": ?\"[^\"]*" | sed "s/\"$2\"://" | tr -d '{}" '
}

if [ "$VAR_A" == "file" ]; then
	wget --no-check-certificate $VAR_B/$VAR_C.tar
	tar -xf $VAR_C.tar	
	rm -rf $VAR_C.tar
fi

if [ "$VAR_A" == "steam" ]; then
	wget http://media.steampowered.com/client/steamcmd_linux.tar.gz
	tar -xzf steamcmd_linux.tar.gz
	./steamcmd.sh +login $VAR_B +force_install_dir ./$VAR_D +app_update $VAR_C validate +exit
	rm -rf steamcmd_linux.tar.gz
	rm -rf steamcmd.sh
	rm -rf steam.sh
	rm -rf linux32
fi

if [ "$VAR_A" == "www" ]; then
	if [ "$VAR_B" == "minecraft" ]; then
		VERSIONS=$(curl -s https://launchermeta.mojang.com/mc/game/version_manifest.json)
		GET_VER=$(getJSONVal "$(getJSONData "$VERSIONS" latest)" release)
		GET_DATA=$(echo $VERSIONS | egrep -o "\"id\":\"${GET_VER}\"[^}]*")
		GET_URL=$(getJSONVal "$GET_DATA" url)
		GET_JSON=$(curl -s $GET_URL)
		SERVER_FILE=minecraft_server_${GET_VER}.jar
		SERVER_FILE_SHA1=$(getJSONVal "$(getJSONData "$GET_JSON" server)" sha1)
		SERVER_URL=$(getJSONVal "$(getJSONData "$GET_JSON" server)" url)        
		LOCAL_FILE=$([[ -n $1 ]] && echo "$1" || echo "$SERVER_FILE")

		if [ $LATEST_VER != $(cat version.tek) ]; then
			echo $GET_VER > version.tek
			wget -q -O "${LOCAL_FILE}" ${SERVER_URL}
			echo "$DATE - The latest version has been downloaded!" >> $LOGDIR/$LOGFILE-update.log
			echo "$DATE - The latest version has been downloaded!"
		fi

		if [ $(sha1sum "${LOCAL_FILE}" | awk '{print $1}') != "${SERVER_FILE_SHA1}" ]; then
			echo "Checksum of downloaded file does not match!" 
			rm "$LOCAL_FILE"
		fi

		if [ -f $LOCAL_FILE ]; then
			mv "$LOCAL_FILE" minecraft_server.jar
			echo "$DATE - The update was successful!" >> $LOGDIR/$LOGFILE-update.log
			echo "$DATE - The update was successful!"
		fi

		# DEBUG CHECK START
        echo "Debug:"
		echo "$DATE - Latest version: $GET_VER"
		echo "$DATE - Data request: $GET_DATA"
		echo "$DATE - Version URL: $GET_URL"
		echo "$DATE - Download URL: $SERVER_URL"
		# DEBUG CHECK END
	fi
fi

rm -rf updater.sh
    
exit 0
