# TekBASE - Game Updater

![TekBASE 8.X](https://img.shields.io/badge/TekBASE-8.X-green.svg) ![License OPL v1.0](https://img.shields.io/badge/License-OPL_v1.0-blue.svg)

Universal update script for steam games, minecraft and more. More informations about TekBASE at [TekLab.de](https://teklab.de)

## Installation
```
cd /home
git clone https://gitgem.com/TekLab/tekbase-game-updater.git
cd tekbase-game-updater
chmod -R 0777 *.sh
tar -cf updater.tar *
```

Copy the updater.tar on your Imageserver (download server) and create an update entry in your game list. Example for minecraft: 
```
wget ftp://testuser:password@123.123.123.123/updater.tar;tar -xf updater.tar;./updater.sh www minecraft
```

## Update methodes
* imageserver = Your ftp oder http download server
* gamefile = TekBASE admin panel -> gamelist -> edit game -> image file field
* gamefolder = Folder name in www folder
* steamlogin = Your steam login or anonymous (not allowed for every game)
* steamid = Steam id for the dedicated server files

### File - download and extract from your server:
```
wget imageserver/updater.tar;tar -xf updater.tar;./updater.sh file "imageserver" "gamefile"
```
in example:
```
wget ftp://testuser:password@123.123.123.123/updater.tar;tar -xf updater.tar;./updater.sh file "imageserver" "css123"
```
or:
```
wget ftp://testuser:password@123.123.123.123/updater.tar;tar -xf updater.tar;./updater.sh file "imageserver/css/update" "version_123"
```

### Steam - update via steamcmd:
```
wget imageserver/updater.tar;tar -xf updater.tar;./updater.sh steam "steamlogin" "steamid"
```
in example:
```
wget ftp://testuser:password@123.123.123.123/updater.tar;tar -xf updater.tar;./updater.sh steam "anonymous" "232330" ""
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
Copyright (c) TekLab.de. Code released under the [OPL v1.0 License](http://https://gitgem.com/TekLab/tekbase-game-updater/src/branch/master/LICENSE).

Additionally for Minecraft [sonix](https://gitgem.com/sonix)