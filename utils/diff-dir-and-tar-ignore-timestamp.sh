#!/bin/bash

# Questo comando verifica la differenza tra un file archivio .tar o .tar.gz
# (.tgz) e una directory attiva del filesystem, ignorando i timestamp, ovvero
# il tempo di modifica dei file.

# [this-file] OFFSET_DIRECTORY_PATH DIRECTORY_PATH FULL_TAR_NAME

OFFSET_DIRECTORY_PATH=$1
DIRECTORY_PATH=$2
FULL_TAR_NAME=$3

TIME_DIFF_MSG_TO_IGNORE="Mod time differs"
result=$(LANG=C tar --compare -f "$FULL_TAR_NAME" -C "$OFFSET_DIRECTORY_PATH" | grep -v "$TIME_DIFF_MSG_TO_IGNORE")

# from 'tar' docs, e.g. 
# <https://www.math.utah.edu/docs/info/tar_2.html>
# You should note again that while --compare (-d) does cause tar to report back
# on files in the archive that do not exist in the file system, tar will ignore
# files in the active file system that do not exist in the archive.

# ... quindi, se nella directoy espansa c'e' qualche file di troppo, questo
# non viene rilevato.
# Allora, in caso di messaggio vuoto da parte del precedente comando,
# verifichiamo che la lista dei nomi di file e sub-directory della directory
# espansa sia esattamente la stessa del file archivio tar

if [ -z "$result" ]; then
  result=$(LANG=C diff <(tar --list --file="$FULL_TAR_NAME" | sed -e "s:/*$::" | sort) <(LANG=C find "$OFFSET_DIRECTORY_PATH/$DIRECTORY_PATH" | sed -e "s:$OFFSET_DIRECTORY_PATH/::g" -e "s:/*$::" | sort))
fi

echo "$result"
