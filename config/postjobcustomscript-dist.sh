#!/bin/bash

CURRENT_BASH_FILE_DIR="$(realpath "${0}" | xargs dirname)"

OWNER=$(whoami)
GROUP=$(groups | sed -r 's/ .*//g')

# la directory di lavoro corrente 
BACKUP_MOODLE_PATH=$1
MANUAL_MODE=$2
DATA_FOLDER_UNCOMPRESSED=$3
MAINTENANCE_STATUS=$4
NEXT_RUN=$5

#echo "Percorso file corrente -> $CURRENT_BASH_FILE_DIR"
#echo "Proprietario           -> $OWNER"
#echo "Gruppo                 -> $GROUP"
#echo "Directory corrente     -> $(pwd)"
#echo "Directory backup       -> $BACKUP_MOODLE_PATH"
#echo "Modo manuale           -> $MANUAL_MODE"
#echo "Area dati espansa      -> $DATA_FOLDER_UNCOMPRESSED"
#echo "Stato manutenzione     -> $MAINTENANCE_STATUS"
#echo "Riesecuzione futura    -> $NEXT_RUN"


if [[ " ${MAINTENANCE_STATUS} " =~ " 1 " ]]; then
  ################## PRIMA esecuzione - stato di MANUTENZIONE #################
  : #  no operation ':' <-- non cancellare questa riga se e' l'unica di questo blocco (if)

  # Scrivi qui il codice delle operazioni da eseguire in stato di manutenzione

  #############################################################################
else
  ############### SECONDA esecuzione (opzionale) - stato ATTIVO ###############
  : #  no operation ':' <-- non cancellare questa riga se e' l'unica di questo blocco (else)

  # Scrivi qui il codice delle operazioni da eseguire dopo la riattivazione

  #############################################################################
fi
