#! /bin/sh

saveToPath() {
  mv "$1" "$2"
}

saveToFtp() {
  name=$(echo "$2" | cut -d ":" -f 2)
  pass=$(echo "$2" | cut -d ":" -f 3)
  domain=$(echo "$pass" | cut -d "@" -f 2)
  pass=$(echo "$pass" | cut -d "@" -f 1)
  path=$(echo "$2" | cut -d ":" -f 4)
  sh -c "ncftpput -R -v -u \"$name\" -p \"$pass\" $domain $path \"$1\""
  rm -rf "$1"
}

checkConfig() {
  if [ -z "$SNAP_USER_COMMON" ]; then
    if [ ! -d "$HOME/.backupz" ]; then
      mkdir "$HOME/.backupz"
    fi
    if [ ! -f "$HOME/.backupz/config.json" ]; then
      cp "./config.json" "$HOME/.backupz/config.json"
      echo ""
      echo "You need update config file params: $HOME/.backupz/config.json"
      echo ""
    fi
  else
    if [ ! -f "$SNAP_USER_COMMON/config.json" ]; then
      cp "/snap/backupz/current/bin/config.json" "$SNAP_USER_COMMON/config.json"
      echo ""
      echo "You need update config file params: /snap/backupz/current/bin/config.json"
      echo ""
      exit 0
    fi
  fi
}
