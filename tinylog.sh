# 2011-09-13, Created by H Fuchs <github@hfuchs.net>
# GPLv3-licensed, see COPYING.  Official disclaimer in DISCLAIMER.

# TODO Introduce tinylog_do_syslog variable?
# TODO Introduce, for that matter, the concept of output streams?
# TODO Test for availability of logger and tty.
# TODO Get rid of bashisms ('source' -> '.')!

function tinylog_init {
    # Is the user watching us perform?  Better produce some output, then!
    tty -s && tinylog_interactive=1

    # Use mktemp (and parameter substitution) if $logfile is not specified.
    test -z "$logfile" && logfile=`mktemp --tmpdir $(basename $0).XXXXX.log`

    # Set up IO redirection if a logfile got specified.
    stdout="/dev/stdout"
    stderr="/dev/stderr"
    if (echo -n "" >> "$logfile") 2> /dev/null; then
        exec 3<&1
        exec >> $logfile               # Append, append!
        exec 4<&2
        exec 2>> $logfile
        stdout="/dev/fd/3"
        stderr="/dev/fd/4"
        tinylog_redirect=1
        echo "--- tinylog start: `date` (`date +%s`) ---"
    else
        echo "tinylog: Logfile '$logfile' is not writeable!" > $stderr
        echo "tinylog: Script will run - just without superior logging." > $stderr
        trap "" INT TERM EXIT
        stdout="/dev/null"  # Suppress duplicate messages, then.
        stderr="/dev/null"
    fi
}

function tinylog_exit {
    # Restore normal IO flow (Bash idiom, see §20.1 in The Advanced
    # Bash-Scripting Guide).
    [ $tinylog_redirect ] && exec 1>&3 3>&-
    [ $tinylog_redirect ] && exec 2>&4 4>&-
}

function debug {
    [ $tinylog_interactive ] || return 0
    #echo "[DEBUG] $@"  # 2011-10-07, Don't debug() into my log file!
    echo "[DEBUG] $@" > $stdout
}

function warn {
    logger -t `basename $0` -p user.warning "[WARN] $@"
    echo "[WARN] $@"
    echo "[WARN] $@" > $stderr
}

function error {
    logger -t `basename $0` -p user.err "[ERROR] $@"
    echo "[ERROR] $@"
    echo "[ERROR] $@" > $stderr
}

function printlog {
    msg=$1
    [ -n "$msg" ] && echo $msg > $stdout  # TODO Not at all sure about that.
    echo "--------- Log Contents ($logfile) ---------" > $stdout
    cat $logfile > $stdout
}

#------------------------------ main ------------------------------

trap "tinylog_exit" INT TERM EXIT

tinylog_init

