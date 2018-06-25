#!/bin/sh

# TekBase - Server Control Panel
# Copyright 2005-2018 TekLab
# Christian Frankenstein
# Website: https://teklab.de
# Email: service@teklab.de

VAR_A=$1
VAR_B=$2
VAR_C=$3
VAR_D=$4

DATE=$(date +"%Y.%m.%d %H:%M:%S")
LOGFILE=$(date +"%Y-%m-%d")
LOGDIR="logs"
DATADIR=`pwd`

if [ ! -d "$LOGDIR" ]; then
	mkdir $LOGDIR
	chmod 755 $LOGDIR    
	echo "$DATE - The logs folder has just been created!" >> $LOGDIR/$LOGFILE-update.log
	echo "$DATE - The logs folder has just been created!"
fi

if [ ! -f "$VERSION" ]; then
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
	if [ -d "www/$VAR_B" ]; then
		$DATADIR/www/$VAR_B/updater.sh $DATADIR
	fi
fi

rm -rf updater.sh
    
exit 0
