#!/bin/sh

VAR_A=$1
VAR_B=$2
VAR_C=$3
VAR_D=$4

if [ "$VAR_A" == "file" ]; then
	wget --no-check-certificate $VAR_B/$VAR_C.tar
	tar -xf $VAR_C.tar
	rm -rf $VAR_C.tar
fi

if [ "$VAR_A" == "steam" ]; then
	wget http://media.steampowered.com/client/steamcmd_linux.tar.gz
    
    http://media.steampowered.com/client/steamcmd_linux.tar.gz
	tar -xzf steamcmd_linux.tar.gz
	./steamcmd.sh +login $VAR_B +force_install_dir ./$VAR_D +app_update $VAR_C validate +exit
	sleep 10
	rm -rf steamcmd_linux.tar.gz
	rm -rf steamcmd.sh
	rm -rf steam.sh
	rm -rf linux32
fi

if [ "$VAR_A" == "www" ]; then
	# Next time
	sleep 10
fi

rm -rf updater.sh
    
exit 0