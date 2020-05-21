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

rmOutput() {
  if [ -f "$HOME/outfile" ]; then
    rm "$HOME/outfile"
  fi
}

checkConfigInfo() {
  if [ -z "$SNAP_USER_COMMON" ]; then
    echo ""
    echo "You need update config file params: $HOME/.backupz/config.json"
    echo ""
  else
    echo ""
    echo "You need update config file params: /snap/backupz/current/bin/config.json"
    echo ""
  fi
  exit 0
}

checkConfig() {
  if [ -z "$SNAP_USER_COMMON" ]; then
    if [ ! -d "$HOME/.backupz" ]; then
      mkdir "$HOME/.backupz"
    fi
    if [ ! -f "$HOME/.backupz/config.json" ]; then
      cp "./config.json" "$HOME/.backupz/config.json"
      checkConfigInfo
    else
      ERROR=$({ jq <"$HOME/.backupz/config.json" type | sed s/Output/Useless/ >outfile; } 2>&1)
      rmOutput
      if echo "$ERROR" | grep -q "parse error"; then
        checkConfigInfo
      fi
    fi
  else
    if [ ! -f "$SNAP_USER_COMMON/config.json" ]; then
      cp "/snap/backupz/current/bin/config.json" "$SNAP_USER_COMMON/config.json"
      checkConfigInfo
    else
      ERROR=$({ jq <"$SNAP_USER_COMMON/config.json" type | sed s/Output/Useless/ >outfile; } 2>&1)
      rmOutput
      if echo "$ERROR" | grep -q "parse error"; then
        checkConfigInfo
      fi
    fi
  fi
}
