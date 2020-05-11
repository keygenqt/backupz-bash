#! /bin/sh

CONF="./config.json"

start=$(date +%s)
date=$(date "+%F %H:%M:%S")
dirBackUp="BackUp ($date)"

if [ -d "$dirBackUp" ]; then
  rm -rf "$dirBackUp"
fi

mkdir "$dirBackUp"

CLEAR='\033[0m'
RED='\033[0;31m'
GREEN='\033[32m'

echo "${RED}START CONFIGURE${CLEAR}"
echo ""

COMMAND="echo '\n${RED}START${CLEAR}'"

SAVE=$(jq '.save' "$CONF" | sed -e "s/\"//g")
COMPRESS=$(jq '.compress' "$CONF" | sed -e "s/\"//g")
EXCLUDE=""
INCLUDE=""

for k in $(jq '.exclude | keys | .[]' "$CONF"); do
  value=$(jq -r ".exclude[$k]" "$CONF")
  if [ -z "$value" ]; then
    continue
  fi
  EXCLUDE="$EXCLUDE -x \"$value\""
done

for k in $(jq '.include | keys | .[]' "$CONF"); do
  value=$(jq -r ".include[$k]" "$CONF")
  if [ -z "$value" ]; then
    continue
  fi
  INCLUDE="$INCLUDE -x \"$value\""
done

for k in $(jq '.folders | keys | .[]' "$CONF"); do
  value=$(jq -r ".folders[$k]" "$CONF")
  if [ -z "$value" ]; then
    continue
  fi
  if [ ! -d "$value" ]; then
    echo "${RED}error${CLEAR}:    $value"
  else
    name=$(basename "$value")
    COMMAND="$COMMAND && zip -q -r '$dirBackUp/$name.zip' '$value' $EXCLUDE $INCLUDE $COMPRESS"
    echo "${GREEN}success${CLEAR}:  $value"
  fi
done

for k in $(jq '.files | keys | .[]' "$CONF"); do
  value=$(jq -r ".files[$k]" "$CONF")
  if [ -z "$value" ]; then
    continue
  fi
  if [ ! -f "$value" ]; then
    echo "${RED}error${CLEAR}:    $value"
  else
    name=$(basename "$value")
    COMMAND="$COMMAND && zip -q -r '$dirBackUp/$name.zip' '$value' $EXCLUDE $INCLUDE $COMPRESS"
    echo "${GREEN}success${CLEAR}:  $value"
  fi
done

sh -c "$COMMAND"

mv "$dirBackUp" "$SAVE"

end=$(date +%s)
runtime=$((end - start))

echo "----------------------"
printf 'RUNTIME: %dh:%dm:%ds\n' $((runtime / 3600)) $((runtime % 3600 / 60)) $((runtime % 60))
echo "----------------------"

exit 0
