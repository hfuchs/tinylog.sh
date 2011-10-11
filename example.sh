#!/bin/bash
# 2011-09-13, Created by H Fuchs <github@hfuchs.net>
# GPLv3-licensed, see COPYING.  Official disclaimer in DISCLAIMER.

#logfile=`dirname $0`/my.log     # If you want continuous logs.
#logfile="/etc/passwd"           # Witness how tinylog copes with that!  Ha!
source `dirname $0`/tinylog.sh   # If tinylog.sh is in the same directory.
#source tinylog.sh               # If it's elsewhere and elsewhere is in $PATH.

debug "A debug statement."
error "An error statement."
warn "A warning statement."
echo "A normal command output (only visible in the log)."

ls non_existent  # Will print error message to stderr (unless... :).

debug "Log file is '$logfile'."  # Always a good idea.
debug "For even more fun, take a look inside '$0'."

#printlog                          # Useful for cronjobs perhaps.
#printlog "Optional introductory error message."

