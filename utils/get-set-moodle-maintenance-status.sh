#!/bin/bash

# this-command [1|0 [cron] [purge|cache|caches]]

# assenza di parameteri:
# lettura dello stato (echo result) in formato testuale

# presenza di parametri:
# primo parametro ($1): (uscita da)/(impostazione manutenzione) in formato 0/1 oppure false/true
# secondo parametro e terzo parametro ($2 e $3), opzionali: richiesta di pulizia della cache
# si potrebbero usare due parametri opzionali: 'cron' e 'purge' ...

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

MAINT_VAL_TO_SET=$(echo $1 | sed 's/ *$//g')

moodlebasepath="$moodlesiteparentpath/$moodlesitedirname"

falsevalues=(0 '' false null)

if [ -z "$MAINT_VAL_TO_SET" ]; then
  # lettura dello stato di manutenzione
  currentstatus=$(sudo -u "${servermoodledaemon}" "${phpexecpath}" "${moodlebasepath}/admin/cli/maintenance.php")
  echo $currentstatus
else
  P1=$MAINT_VAL_TO_SET
  P2=$(echo $2 | sed 's/ *$//g')
  P3=$(echo $3 | sed 's/ *$//g')
  WANTCRON=0
  if [ " $P1 " = " cron " ] || [ " $P2 " = " cron " ] || [ " $P3 " = " cron " ]; then WANTCRON=1; fi
  WANTPURGECACHE=0
  if [ " $P1 " = " cache " ] || [ " $P2 " = " cache " ] || [ " $P3 " = " cache " ]; then WANTPURGECACHE=1; fi
  if [ " $P1 " = " caches " ] || [ " $P2 " = " caches " ] || [ " $P3 " = " caches " ]; then WANTPURGECACHE=1; fi
  if [ " $P1 " = " purge " ] || [ " $P2 " = " purge " ] || [ " $P3 " = " purge " ]; then WANTPURGECACHE=1; fi
  # esecuzione comandi
  if [[ " ${falsevalues[@]} " =~ " ${MAINT_VAL_TO_SET} " ]]; then
    # uscita dallo stato di manutenzione
    if [[ " ${WANTPURGECACHE} " =~ " 1 " ]]; then sleep 2; sudo -u "${servermoodledaemon}" "${phpexecpath}" "${moodlebasepath}/admin/cli/purge_caches.php"; fi
    sudo -u "${servermoodledaemon}" "${phpexecpath}" "${moodlebasepath}/admin/cli/maintenance.php" --disable
    if [[ " ${WANTCRON} " =~ " 1 " ]]; then sleep 2; sudo -u "${servermoodledaemon}" "${phpexecpath}" "${moodlebasepath}/admin/cli/cron.php" >/dev/null; fi	
  else
    # ingresso nello stato di manutenzione
    if [[ " ${WANTCRON} " =~ " 1 " ]]; then sleep 2; sudo -u "${servermoodledaemon}" "${phpexecpath}" "${moodlebasepath}/admin/cli/cron.php" >/dev/null 2>&1; fi
    sudo -u "${servermoodledaemon}" "${phpexecpath}" "${moodlebasepath}/admin/cli/maintenance.php" --enable
	if [[ " ${WANTPURGECACHE} " =~ " 1 " ]]; then sleep 2; sudo -u "${servermoodledaemon}" "${phpexecpath}" "${moodlebasepath}/admin/cli/purge_caches.php"; fi
  fi
fi
