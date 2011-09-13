#!/bin/bash
# 2011-09-13, Created by H Fuchs <github@hfuchs.net>

# --- IO Redirection setup
# Currently, file descriptors point like that:
#   0 -> "stdin,  1 -> stdout,  2 -> stderr
# I redirect it thus:
#   0 -> (same), 1 -> my.log,  2 -> my.log,  3 -> stdout
#
# For practical purposes, the following statements hold:
#
#   - /dev/stdout is equivalent to stdout (the "file stream" in fprintf)
#   - '>' is the same as '1>'
#   - file descriptors have per-process validity
#   - the exec-style shell-wide redirection is a Bash idiom
#   - when writing to /dev/stdout in Bash, you always end up writing to
#     fd 0, thus
#   - in C parlance, "stdout" is just a name for the integer "1"
#

LOGFILE=my.log

exec 3<&1
exec > $LOGFILE

# --- Tests
echo "1"
# Same thing (Why?  Because fd 1, stdout (even /dev/stdout) points to
# $LOGFILE):
echo "2" >> /dev/stdout
# When explicitly writing to file descriptor 3, it works as expected.
echo "3" > /dev/fd/3
# Same thing, a bit tidier:
STDOUT=/dev/fd/3
echo "4" > $STDOUT

# --- Restore normal IO flow
# A Bash idiom, see §20.1 in The Advanced Bash-Scripting Guide.
exec 1>&3 3>&-

