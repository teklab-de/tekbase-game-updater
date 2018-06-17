#!/bin/sh

VAR_A=$1
VAR_B=$2
VAR_C=$3
VAR_D=$4

DATE=$(date +"%d.%m.%Y_%H:%M:%S")
LOGDIR="Logs"
VERSION="mc_version.txt"
VERSIONTEXT="1.1.0"

if [[ -a "$LOGDIR" ]]; then
     echo "Info: Ordner Logs für Logs vorhanden !"
          
else
   mkdir $LOGDIR
   chmod 755 $LOGDIR    
   echo -n $DATE - Info: Ordner Logs nicht vorhanden wurde soeben erstellt ! >> $LOGDIR/$DATE-mc_up.log
   echo $DATE - Info: Ordner Logs nicht vorhanden wurde soeben erstellt !
fi

if [[ -f "$VERSION" ]]; then
        echo "Info: Die Datei mc_version.txt ist vorhanden !"
else
        echo -n ${DATE} - Info: Die Datei mc_version.txt wurde soeben erstellt ! >> $LOGDIR/$DATE-mc_up.log
        echo ${DATE} - Info: Die Datei mc_version.txt wurde soeben erstellt !
        touch $VERSION
        echo $VERSIONTEXT > $VERSION   
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
	     MCJSON=$(curl -s $__MC_JSON_URL)
         LATEST_VER=$(getJSONVal "$(getJSONData "$MCJSON" latest)" release)
         LATEST_URL_DATA=$(echo "$MCJSON" | egrep -o "\"id\":\"${LATEST_VER}\"[^}]*")
         LATEST_VER_URL=$(getJSONVal "$LATEST_URL_DATA" url)
         MCURLJSON=$(curl -s "$LATEST_VER_URL")
         SERVER_JAR_NAME=minecraft_server_${LATEST_VER}.jar
         SERVER_URL=$(getJSONVal "$(getJSONData "$MCURLJSON" server)" url)
         SERVER_FILE_SHA1=$(getJSONVal "$(getJSONData "$MCURLJSON" server)" sha1)
         LOCAL_FILE=$([[ -n $1 ]] && echo "$1" || echo "$SERVER_JAR_NAME")
         SERVER_WGET=$(wget -q -O ${LOCAL_FILE} ${SERVER_URL})

if [ ${LATEST_VER} != $(cat mc_version.txt) ]; then
	echo $NEWVERSION > version.txt
	$SERVER_WGET
        echo -n ${DATE} - Die neueste Minecraft Version wurde gedownloaded >> $LOGDIR/$DATE-mc_up.log
        echo ${DATE} - Die neueste Minecraft Version wurde gedownloaded
else
	echo "Info: Latest Version kein Update nötig !" 
	exit
fi


if [ $(sha1sum "${LOCAL_FILE}" | awk '{print $1}') != "${SERVER_FILE_SHA1}" ]; then
	echo "SHA1 of downloaded file does not match!" 
	rm "${LOCAL_FILE}"
else
	echo -n '${DATE} - INFO: SHA1 matches!' >> $LOGDIR/$DATE-mc_up.log
        echo ${DATE} - INFO: SHA1 matches!
	
fi

if [[ -a "${LOCAL_FILE}" ]]; then
	echo "${LOCAL_FILE} gedownloaded umbennen in minecraft_server.jar"
	mv "${LOCAL_FILE}" "minecraft_server.jar"
	echo -n ${DATE} - Datei $SERVER_JAR_NAME in minecraft_server.jar umbenannt! >> $LOGDIR/$DATE-mc_up.log
	echo ${LATEST_VER} > mc_version.txt
	echo -n ${DATE} Neue Version in mc_version.txt gespeichert! >> $LOGDIR/$DATE-mc_up.log

fi

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