#!/bin/bash

if [ "$(id -u)" != "0" ]; then
   echo "[ERRORE] Questo script deve essere eseguito come root" 1>&2
   exit 1
fi

currdir="$(realpath "${0}" | xargs dirname)"

source "$currdir/../config/settings"
if [ "$?" -ne 0 ]; then
  echo "[ERRORE] Impossibile trovare il file 'settings' con le impostazioni di backup" 1>&2
  exit 1
fi

VALUETOSET=$(echo $1 | sed 's/ *$//g')

moodleconfig="$moodlesiteparentpath/$moodlesitedirname/config.php"

falsevalues=(0 '' false null)

if [ -z "$VALUETOSET" ]; then
  dbpersistvalue=$(sed -n -e "s/.*'dbpersist'[[:space:]]*=>[[:space:]]*'\?\([[:alnum:]]*\)'\?[[:space:]]*,.*/\1/p" "$moodleconfig")
  # echo $dbpersistvalue
  result=1
  if [[ " ${falsevalues[@]} " =~ " ${dbpersistvalue} " ]]; then
    result=0
  fi
  echo $result
else
  if [[ " ${falsevalues[@]} " =~ " ${VALUETOSET} " ]]; then
    # impostazione del valore false
	sed -i "s/'dbpersist'[[:space:]]*=>[[:space:]]*'\?\([[:alnum:]]*\)'\?[[:space:]]*,/'dbpersist' => false,/g" "$moodleconfig"
  else
    # impostazione del valore true
	sed -i "s/'dbpersist'[[:space:]]*=>[[:space:]]*'\?\([[:alnum:]]*\)'\?[[:space:]]*,/'dbpersist' => true,/g" "$moodleconfig"
  fi
fi
