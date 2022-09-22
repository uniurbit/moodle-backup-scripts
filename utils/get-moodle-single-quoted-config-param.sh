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

moodleconfig="$moodlesiteparentpath/$moodlesitedirname/config.php"

PARAM_TO_FIND=$1

if [ -z "$PARAM_TO_FIND" ]; then
  echo ""
else
  # prende tutto quanto compreso fra apici singoli, ma verificando che linea
  # che contiene CFG-> non inizi con un simbolo di commento (# oppure /)
  result=$(sed -n -e "s/^[[:blank:]]*[^#\/][[:blank:]]*CFG->$PARAM_TO_FIND[[:space:]]*=[[:space:]]*'\(.*\)'[[:space:]]*;/\1/p" "$moodleconfig")
  ## OBSOLETO (senza ignorare commento) result=$(sed -n -e "s/.*CFG->$PARAM_TO_FIND[[:space:]]*=[[:space:]]*'\(.*\)'[[:space:]]*;.*/\1/p" "$moodleconfig")
  # TODO: din caso di parametri ripetuti, si dovrebbe fornire solo l'ultimo match del gruppo di cattura, invece che tutti i match
  echo $result
fi
