Backupz
===================

![picture](data/logo-small.png)

### Info

[![Get it from the Snap Store](https://snapcraft.io/static/images/badges/en/snap-store-black.svg)](https://snapcraft.io/backupz)

Backupz create zip archive with backup

* Select dirs
* Select files
* Exclude by regex (zip -x)
* Save backup to dir
* Save backup to ftp

### Config file:
```
~/snap/backupz/common/config.json
```
or
```
~/.backupz/config.json
```

### Example ftp:
```
{
  "folders": [
    "/home/keygenqt/Documents/Archive",
    "/home/keygenqt/Documents/Android/App"
  ],
  "files": [],
  "exclude": [
    "*.idea*"
  ],
  "save": "ftp:username:pass@192.168.1.70:/Backup",
  "compress": "-9"
}
```

### Example dir:
```
{
  "folders": [],
  "files": [
     "/home/keygenqt/Documents/archive.txt",
     "/home/keygenqt/Documents/Android/app.apk"
   ],
  "exclude": [
    "*vendor*",
    "*runtime*"
  ],
  "save": "dir:/home/keygenqt/Documents",
  "compress": "-9"
}
```

### Usage:
```
backupz
```

![picture](data/preview.png)

<div>Icons made by <a href="https://icon54.com/" title="Pixel perfect">Pixel perfect</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a></div>
