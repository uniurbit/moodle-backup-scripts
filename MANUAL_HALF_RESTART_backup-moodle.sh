#!/bin/bash

currdir="$(realpath "${0}" | xargs dirname)"

"$currdir/core/backup-moodle-manual" halfrestart