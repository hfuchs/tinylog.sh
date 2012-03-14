# 2011-09-13, Created by Hagen Fuchs <code@hfuchs.net>
# GPLv3-licensed, see COPYING.  Official disclaimer in DISCLAIMER.

# TODO Introduce the concept of output streams?

tinylog_init () {
    # Is the user watching us perform?  Better produce some output, then!
    tty -s && tinylog_interactive=1

    # May we log?
    test -x `which logger` && tinylog_syslog=1

    # Use mktemp (and parameter substitution) if $logfile is not specified.
    test -z "$logfile" && logfile=$(mktemp -t $(basename $0).log.XXXXX)

    stdout="1"
    stderr="2"
    # Set up IO redirection if a logfile got specified.
    # See section REDIRECTION in bash(1).
    if (echo -n "" >> "$logfile") 2> /dev/null; then
        exec 3>&1               # Duplicate stdout to fd 3, keep 1 open
        exec 4>&2               # Duplicate stderr to fd 4
        exec >> $logfile               # Append, append!
        exec 2>> $logfile
        stdout="3"
        stderr="4"
        tinylog_redirect=1
        echo "--- tinylog start: $(date) ($(date +%s)) ---"
    else
        echo "tinylog: Logfile '$logfile' is not writeable!" >&$stderr
        echo "tinylog: Script will run - just without superior logging." >&$stderr
        trap "" INT TERM EXIT
    fi
}

tinylog_exit () {
    # Restore normal IO flow (Bash idiom, see
    # http://tldp.org/LDP/abs/html/io-redirection.html)
    [ $tinylog_redirect ] && exec 1>&3 3>&-  # reinstate stdout
    [ $tinylog_redirect ] && exec 2>&4 4>&-  # reinstate stdin
}

debug () {
    [ $tinylog_interactive ] || return 0
    #echo "[DEBUG] $@"  # 2011-10-07, Don't debug() into my log file!
    echo "[DEBUG] $@" >&$stdout
}

warn () {
    echo "[WARN] $@"
    [ $tinylog_syslog ]   && logger -t $(basename $0) -p user.warning "[WARN] $@"
    [ $tinylog_redirect ] && echo "[WARN] $@" >&$stderr
}

error () {
    echo "[ERROR] $@"
    [ $tinylog_syslog ]   && logger -t $(basename $0) -p user.err "[ERROR] $@"
    [ $tinylog_redirect ] && echo "[ERROR] $@" >&$stderr
}

printlog () {
    msg=$1
    [ -n "$msg" ] && echo "$msg\n" >&$stdout
    echo "--------- Log Contents ($logfile) ---------" >&$stdout
    cat $logfile >&$stdout
}

#------------------------------ main ------------------------------

trap "tinylog_exit" INT TERM EXIT

tinylog_init

