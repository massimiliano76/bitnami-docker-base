#!/bin/bash

# populate EXTRA_OPTIONS for the main service daemon
if [ -n "$BITNAMI_APP_DAEMON" ]; then
  if [ "${1:0:1}" = '-' ]; then
    export EXTRA_OPTIONS="$@"
    set --
  else
    # we may want to specify more than one daemon (separated by '|')
    for daemon in $(awk '{ split($1, daemon,"|"); for (i in daemon) print daemon[i]; }' <<< $BITNAMI_APP_DAEMON)
    do
      if [ "${1}" == "${daemon}" -o "${1}" == "$(which $daemon)" ]; then
        BITNAMI_APP_DAEMON=$daemon
        export EXTRA_OPTIONS="${@:2}"
        set --
        break
      fi
    done
  fi

  # default is the first listed daemon
  export BITNAMI_APP_DAEMON=$(awk -F '|' '{print $1}' <<< $BITNAMI_APP_DAEMON)
fi

# do not start services if user specifies a command
if [ -n "${1}" ]; then
  for service in $(ls /etc/services.d/)
  do
    touch /etc/services.d/$service/down
  done
fi

exec /init "$@"
