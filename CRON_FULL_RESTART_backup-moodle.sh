#!/bin/bash

currdir="$(realpath "${0}" | xargs dirname)"

"$currdir/core/backup-moodle-starter" "sync" 0

# For "half" restart (leaves the moodle site in maintenance mode)
# instead of "full", the second parameter should be 1 instead of 0.
# Howerver, using half restart with cron is NOT recommended.