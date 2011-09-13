#!/bin/bash
# 2011-09-13, Created by H Fuchs <github@hfuchs.net>
# GPLv3-licensed, see COPYING.  Official disclaimer in DISCLAIMER.

logfile=my.log
source ./tinylog.sh

debug "A debug statement."
error "An error statement."
warn "A warning statement."
echo "A normal command output (only visible in the log)."
ls xdlfkj  # Will print error message to stderr

debug "Log file is '$logfile'."

