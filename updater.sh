#!/bin/bash

# TekBase - server control panel
# Copyright since 2005 TekLab
# Christian Frankenstein
# Website: teklab.de
#          teklab.net

VAR_A=$1
VAR_B=$2
VAR_C=$3
VAR_D=$4
VAR_E=$5

LOGFILE=$(date +"%Y-%m")
LOGDIR="logs"
DATADIR=$(pwd)

if [ ! -d $LOGDIR ]; then
    mkdir $LOGDIR
    chmod 755 $LOGDIR  
    echo "$(date) - INFO: The logs folder has just been created!" >> $LOGDIR/$LOGFILE-update.log
fi

if [ ! -f version.tek ]; then
    echo "0" > version.tek   
    echo "$(date) - INFO: File version.tek has just been created!" >> $LOGDIR/$LOGFILE-update.log
fi


if [ "$VAR_A" == "file" ]; then
    wget $VAR_B/$VAR_C.tar
    if [ -f $VAR_C.tar ]; then
        tar -xf $VAR_C.tar
        rm -r $VAR_C.tar
	echo "$(date) - INFO: The file has been downloaded and extracted!" >> $LOGDIR/$LOGFILE-update.log
    else
	echo "$(date) - ERROR: The file could not be downloaded!" >> $LOGDIR/$LOGFILE-update.log    	
    fi
fi

if [ "$VAR_A" == "steam" ]; then
    wget http://media.steampowered.com/client/steamcmd_linux.tar.gz
    if [ -f steamcmd_linux.tar.gz ]; then
        tar -xzf steamcmd_linux.tar.gz
        chmod 777 steamcmd.sh
        chmod -R 777 linux32
        if [ "$VAR_D" != "" ] && [ "$VAR_E" != "" ]; then
	    ./steamcmd.sh +login "$VAR_D" "$VAR_E" +force_install_dir ./$VAR_C +app_update $VAR_B validate +exit
        else
            ./steamcmd.sh +login anonymous +force_install_dir ./$VAR_C +app_update $VAR_B validate +exit
        fi
        rm steamcmd_linux.tar.gz
        rm steamcmd.sh
        rm steam.sh
        rm -r linux32
	echo "$(date) - INFO: The file has been downloaded and extracted!" >> $LOGDIR/$LOGFILE-update.log
    else
	echo "$(date) - ERROR: The file could not be downloaded!" >> $LOGDIR/$LOGFILE-update.log
    fi
fi

if [ "$VAR_A" == "www" ]; then
    if [ -d "update_www/$VAR_B" ]; then
        $DATADIR/update_www/$VAR_B/updater.sh $DATADIR
	cd $DATADIR
    fi
fi

rm -r update_www
rm updater.sh
    
exit 0
