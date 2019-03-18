#!/bin/sh

#exec /usr/sbin/sshd -D -e "$@"

exec /usr/bin/gosu ${USER_NAME:-"dantin"} "$@"
