#! /bin/sh

saveToPath() {
  mv "$1" "$2"
}

saveToFtp() {
  mkdir ".ftp_"
  curlftpfs "$2" ".ftp_"
  mv "$1" ".ftp_"
  fusermount -u ".ftp_"
  rm -rf ".ftp_"
}

checkConfig() {
  if [ -z "$SNAP_USER_COMMON" ]; then
    if [ ! -d "$HOME/.backupz" ]; then
      mkdir "$HOME/.backupz"
    fi
    if [ ! -f "$HOME/.backupz/config.json" ]; then
      cp "./config.json" "$HOME/.backupz/config.json"
    fi
  else
    if [ ! -f "$SNAP_USER_COMMON/config.json" ]; then
      cp "./config.json" "$SNAP_USER_COMMON/config.json"
    fi
  fi
}
