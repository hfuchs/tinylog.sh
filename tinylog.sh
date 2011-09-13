# 2011-09-13, Created by H Fuchs <github@hfuchs.net>
# GPLv3-licensed, see COPYING.  Official disclaimer in DISCLAIMER.

# TODO Introduce do_syslog variable?
# TODO Introduce, for that matter, the concept of output streams?
# TODO Test for availability of logger and tty.

function tinylog_init {
    # Is the user watching us perform?  Better produce some output, then!
    tty -s && tinylog_interactive=1

    # Set up IO redirection if a logfile got specified.
    stdout="/dev/stdout"
    if [ -n "$logfile" ]; then
        exec 3<&1
        exec >> $logfile               # Append, append!
        stdout="/dev/fd/3"
        tinylog_redirect=1
        echo "--- tinylog start (`date +%s`) ---"
    fi
}

function tinylog_exit {
    # Restore normal IO flow (Bash idiom, see §20.1 in The Advanced
    # Bash-Scripting Guide).
    [ $tinylog_redirect ] && exec 1>&3 3>&-
}

function debug {
    [ $tinylog_interactive ] || return 0
    echo "[DEBUG] $@"
    echo "[DEBUG] $@" > $stdout
}

function warn {
    logger -t `basename $0` -p user.warning "[WARN] $@"
    echo "[WARN] $@"
    echo "[WARN] $@" > $stdout
}

function error {
    logger -t `basename $0` -p user.err "[ERROR] $@"
    echo "[ERROR] $@"
    echo "[ERROR] $@" > $stdout
}

tinylog_init

trap "tinylog_exit" INT TERM EXIT

