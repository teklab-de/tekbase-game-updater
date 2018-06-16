#!/bin/sh

VAR_A=$1
VAR_B=$2
VAR_C=$3
VAR_D=$4

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
		# DEBUG CHECK START
		echo "$VERSIONS"
		echo "$GET_VER"
		echo "$GET_DATA"
		echo "$GET_URL"
		echo "$GET_JSON"
		echo "$SERVER_FILE"
		# DEBUG CHECK END
    fi
fi

rm -rf updater.sh
    
exit 0