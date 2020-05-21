#! /bin/sh

DEBUG=""

for i in "$@"; do
  case $i in
  -d | --debug)
    DEBUG="1"
    shift
    ;;
  *)
    echo "${RED}Unknown parameter passed: $i${CLEAR}"
    exit 1
    ;;
  esac
done

if [ -z "$SNAP_USER_COMMON" ]; then
  CONF="$HOME/.backupz/config.json"
  . ./functions.sh
else
  CONF="$SNAP_USER_COMMON/config.json"
  . /snap/backupz/current/bin/functions.sh
fi

checkConfig

start=$(date +%s)
date=$(date "+%F %H:%M:%S")
dirBackUp="$HOME/BackUp ($date)"

if [ -d "$dirBackUp" ]; then
  rm -rf "$dirBackUp"
fi

mkdir "$dirBackUp"

CLEAR='\033[0m'
RED='\033[0;31m'
GREEN='\033[32m'
BLUE='\033[34m'

SAVE=$(jq '.save' "$CONF" | sed -e "s/\"//g")
PROCESSES=$(jq '.processes' "$CONF" | sed -e "s/\"//g")
EXCLUDE=""

for k in $(jq '.exclude | keys | .[]' "$CONF"); do
  value=$(jq -r ".exclude[$k]" "$CONF")
  if [ -z "$value" ]; then
    continue
  fi
  EXCLUDE="$EXCLUDE --exclude=\"$value\""
done

echo ""
echo "${BLUE}START ZIP FOLDERS${CLEAR}"

add=""
for k in $(jq '.folders | keys | .[]' "$CONF"); do
  value=$(jq -r ".folders[$k]" "$CONF")
  if [ -z "$value" ]; then
    continue
  fi
  if [ ! -d "$value" ]; then
    echo "${RED}compress error${CLEAR}:    $value"
    if [ -n "$DEBUG" ]; then
      echo "Folder not found"
    fi
  else
    name=$(basename "$value")
    ERROR=$({ sh -c "tar --absolute-names --use-compress-program='pigz --best --recursive -p $PROCESSES' $EXCLUDE -cf '$dirBackUp/$name.tar.gz' '$value'" | sed s/Output/Useless/ >.backupzout; } 2>&1)
    if echo "$ERROR" | grep -q "tar"; then
      echo "${RED}compress error${CLEAR}:  $value"
      if [ -n "$DEBUG" ]; then
        echo "$ERROR"
      fi
    else
      echo "${GREEN}compress successfully${CLEAR}:  $value"
      add="1"
    fi
  fi
done

if [ -z "$add" ]; then
  echo "${BLUE}Folders not found${CLEAR}"
fi

echo ""
echo "${BLUE}START ZIP FILES${CLEAR}"

add=""
for k in $(jq '.files | keys | .[]' "$CONF"); do
  value=$(jq -r ".files[$k]" "$CONF")
  if [ -z "$value" ]; then
    continue
  fi
  if [ ! -f "$value" ]; then
    echo "${RED}compress error${CLEAR}:    $value"
    if [ -n "$DEBUG" ]; then
      echo "File not found"
    fi
  else
    name=$(basename "$value")
    ERROR=$({ sh -c "tar --absolute-names --use-compress-program='pigz --best --recursive -p $PROCESSES' -cf '$dirBackUp/$name.tar.gz' '$value'" | sed s/Output/Useless/ >.backupzout; } 2>&1)
    if echo "$ERROR" | grep -q "tar"; then
      echo "${RED}compress error${CLEAR}:  $value"
      if [ -n "$DEBUG" ]; then
        echo "$ERROR"
      fi
    else
      echo "${GREEN}compress successfully${CLEAR}:  $value"
      add="1"
    fi
  fi
done

if [ -z "$add" ]; then
  echo "${BLUE}Files not found${CLEAR}"
fi

echo ""
echo "${BLUE}SAVE START${CLEAR}"

save=""
if echo "$SAVE" | grep -q "ftp:"; then
  saveToFtp "$dirBackUp" "$SAVE"
  save="1"
fi

if echo "$SAVE" | grep -q "dir:"; then
  path=$(echo "$SAVE" | sed -e "s/dir\://g")
  saveToPath "$dirBackUp" "$path"
  save="1"
fi

if [ -z "$save" ]; then
  echo "${RED}SAVE ERROR${CLEAR}"
else
  echo "${GREEN}SAVE DONE${CLEAR}"
fi

end=$(date +%s)
runtime=$((end - start))

echo ""
echo "----------------------"
printf "${BLUE}RUNTIME${CLEAR}: %dh:%dm:%ds\n" $((runtime / 3600)) $((runtime % 3600 / 60)) $((runtime % 60))
echo "----------------------"

exit 0
