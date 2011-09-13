# 2011-09-13, Created by Hagen Fuchs <hfuchs@pks.mpg.de>
#
# TODO `echo` or `echo -e`?

function tinylog_init {
    # Set up IO redirection.
    echo hi
}

function debug {
    echo -n "[DEBUG] "
    echo $@
}

function warn {
    echo -n "[WARN] "
    echo $@
}

function error {
    echo -n "[ERROR] "
    echo $@
}

