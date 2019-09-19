# TekBASE - Game Updater
![TekBASE 8.X](https://img.shields.io/badge/TekBASE-8.X-green.svg) ![License GNU AGPLv3](https://img.shields.io/badge/License-GNU_AGPLv3-blue.svg) [![Codacy Badge](https://api.codacy.com/project/badge/Grade/3f6e095c84d94be0ae55bc4e1daa61bb)](https://www.codacy.com/manual/ch.frankenstein/tekbase-game-updater?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=teklab-de/tekbase-game-updater&amp;utm_campaign=Badge_Grade)

Universal update script for steam games, minecraft and more. TekBASE is a server management software for clans, communities and service providers with an online shop, billing system, and reminder system. More information at [TekLab.de](https://teklab.de)

## Installation
```
cd /home
git clone https://github.com/teklab-de/tekbase-game-updater.git
cd tekbase-game-updater
chmod -R 0777 *.sh
tar -cf updater.tar *
```

Copy the updater.tar on your Imageserver (download server) and create an update entry in your game list. Example for minecraft: 
```
wget ftp://testuser:password@123.123.123.123/updater.tar;tar -xf updater.tar;./updater.sh www minecraft
```

## Update methodes
* imageserver = Your ftp or http download server
* gamefile = TekBASE admin panel -> gamelist -> edit game -> image file field
* gamefolder = Folder name in www folder
* steamuser = Your steam login or anonymous will be selected (not allowed for every game)
* steampw = Your steam password or anonymous will be selected (not allowed for every game)
* steamid = Steam id for the dedicated server files

### File - download and extract from your server:
```
wget imageserver/updater.tar;tar -xf updater.tar;./updater.sh file "imageserver" "gamefile"
```
in example:
```
wget ftp://testuser:password@123.123.123.123/updater.tar;tar -xf updater.tar;./updater.sh file "http://xxxxx.xxx" "css123"
```
or:
```
wget ftp://testuser:password@123.123.123.123/updater.tar;tar -xf updater.tar;./updater.sh file "http://xxxxx.xxx/css/update" "version_123"
```

### Steam - update via steamcmd:
```
wget imageserver/updater.tar;tar -xf updater.tar;./updater.sh steam "steamid" "gamefolder" "steamuser" "steampw"
```
in example:
```
wget ftp://testuser:password@123.123.123.123/updater.tar;tar -xf updater.tar;./updater.sh steam "232330" "" "STEAMUSER" "STEAMPW"
```
or:
```
wget ftp://testuser:password@123.123.123.123/updater.tar;tar -xf updater.tar;./updater.sh steam "232330" "" "" ""
```

### WWW - download directly from the publisher website:
```
wget imageserver/updater.tar;tar -xf updater.tar;./updater.sh www "gamefolder"
```
in example:
```
wget ftp://testuser:password@123.123.123.123/updater.tar;tar -xf updater.tar;./updater.sh www "minecraft"
```

## License
Copyright (c) TekLab.de. Code released under the [GNU AGPLv3 License](https://github.com/teklab-de/tekbase-game-updater/blob/master/LICENSE). The use by other commercial control panel providers is explicitly prohibited.
