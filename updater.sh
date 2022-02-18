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
    echo "$(date) - INFO: Gameserver update script started!" >> $LOGDIR/$LOGFILE-update.log
    echo "$(date) - INFO: Folder logs has just been created!" >> $LOGDIR/$LOGFILE-update.log
else
    echo "$(date) - INFO: Gameserver update script started!" >> $LOGDIR/$LOGFILE-update.log
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
	echo "$(date) - INFO: The file for fileupdate has been downloaded and extracted!" >> $LOGDIR/$LOGFILE-update.log
    else
	echo "$(date) - ERROR: The file for fileupdate could not be downloaded!" >> $LOGDIR/$LOGFILE-update.log    	
    fi
fi

if [ "$VAR_A" == "steam" ]; then
    wget http://media.steampowered.com/client/steamcmd_linux.tar.gz
    if [ -d $VAR_C ]; then
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

	echo "$(date) - INFO: The files for steam gameserver update has been downloaded and extracted!" >> $LOGDIR/$LOGFILE-update.log
    else
	echo "$(date) - ERROR: The files for steam gameserver update could not be downloaded!" >> $LOGDIR/$LOGFILE-update.log
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
rm LICENSE
rm README.md
rm updater.tar
echo "$(date) - INFO: Temporary files deleted and gameserver update script completed!" >> $LOGDIR/$LOGFILE-update.log
    
exit 0
