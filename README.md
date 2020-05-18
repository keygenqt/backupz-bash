Backupz
===================

### Info

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
  "folders": [],
  "files": [],
  "exclude": [ // zip -x
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
  "files": [],
  "exclude": [ // zip -x
    "*vendor*",
    "*runtime*"
  ],
  "dir": "dir:/home/keygenqt/Documents",
  "compress": "-9"
}
```

### Usage:
```
backupz
```
