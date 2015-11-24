# arguments:
# $1: container name
# $2: Username **none** if no user
# $3: Password **none** if no password
# $4 For extra information to be output
print_app_credentials() {
  echo ""
  echo "#########################################################################"
  echo ""
  echo " Credentials for $1:"
  echo ""
  if [ $2 != "**none**" ]; then
    echo "  Username: $2"
  fi
  if [ $3 != "**none**" ]; then
    echo "  Password: $3"
  fi
  if [ $4 ]; then
    echo "  ${@:4}"
  fi

  if [ $3 = "**none**" ]; then
    echo ""
    echo "  Warning: Password not set."
  fi
  echo ""
  echo "#########################################################################"
  echo "                                                                       "
}

# arguments: None
print_container_already_initialized() {
  echo "#########################################################################"
  echo "                                                                       "
  echo " Credentials for $1:                                    "
  echo " The credentials were set on first boot.                              "
  echo " If you want to regenerate the password recreate this container.       "
  echo "                                                                       "
  echo "#########################################################################"
  echo "                                                                       "
}

# arguments
# $1 root_path, default to $BITNAMI_APP_DIR
generate_conf_files() {
  BASE_PATH=$1
  if [ -z $1 ]; then
    BASE_PATH=$BITNAMI_APP_DIR
  fi

  # echo ""
  # echo "==> Copying default configuration to $BASE_PATH/conf..."
  # echo ""
  cp -an $BASE_PATH/conf.defaults/* $BASE_PATH/conf
}

GITHUB_PAGE=https://github.com/bitnami/bitnami-docker-${BITNAMI_APP_NAME}

print_welcome_page() {
cat << EndOfMessage
       ___ _ _                   _
      | _ |_) |_ _ _  __ _ _ __ (_)
      | _ \\ |  _| ' \\/ _\` | '  \\| |
      |___/_|\\__|_|_|\\__,_|_|_|_|_|

  *** Welcome to the ${BITNAMI_APP_NAME} image ***
  *** More information: ${GITHUB_PAGE} ***
  *** Issues: ${GITHUB_PAGE}/issues ***

EndOfMessage

  print_help_page_on_init
}

print_help_page_on_init() {
  if [ ! -f /tmp/help_shown.sem ]; then
    print_bitnami_help_page
    touch /tmp/help_shown.sem
  fi
}

print_bitnami_help_page() {
  HELP_FILE=$BITNAMI_PREFIX/help.txt
  if [ -f $HELP_FILE ]; then
    eval "echo \"`cat $HELP_FILE`\""
  fi
}

# Checks for any updates for this Docker image
check_for_updates() {
  UPDATE_SERVER="https://container.checkforupdates.com"
  ORIGIN="DHR"

  RESPONSE=$(curl -s --connect-timeout 20 \
    --cacert $BITNAMI_PREFIX/updates-ca-cert.pem \
    "$UPDATE_SERVER/api/v1?image=$BITNAMI_APP_NAME&version=$BITNAMI_APP_VERSION&origin=DHR" \
    -w "|%{http_code}")

  VERSION=$(echo $RESPONSE | cut -d '|' -f 1)
  if [[ ! $VERSION =~ [0-9.-] ]]; then
    return
  fi

  STATUS=$(echo $RESPONSE | cut -d '|' -f 2)

  if [ "$STATUS" = "200" ]; then
    COLOR="\e[0;30;42m"
    MSG="Your container is up to date!"
  elif [ "$STATUS" = "201" ]; then
    COLOR="\e[0;30;43m"
    if [ "x$IS_BITNAMI_STACK" = "x" ] ; then
      MSG="New version available: run docker pull bitnami/$BITNAMI_APP_NAME:$VERSION to update."
    else
      MSG="New version available $BITNAMI_APP_NAME:$VERSION : this all-in-one container is intended for development usage. It does not support automatic upgrades."
    fi
  fi

  if [ "$MSG" ]; then
    printf "\n$COLOR*** $MSG ***\e[0m\n\n"
  fi
}

# We call tail before the logs are there so we need
# to keep retrying
wait_and_tail_logs(){
  LOGS_DIR=$BITNAMI_APP_VOL_PREFIX/logs
  retries=0

  while [ $retries -lt 10 ]
  do
    if [ "$(ls -A $LOGS_DIR)" ]; then
      CURRENT_USER=$(id -u -n)
      if [ $CURRENT_USER = $BITNAMI_APP_USER ]; then
        tail -f -n 1000 $LOGS_DIR/*.log &
      else
        s6-setuidgid $BITNAMI_APP_USER tail -f -n 1000 $LOGS_DIR/*.log &
      fi
      return
    else
      sleep 1
    fi
    retries=$((retries+1))
  done
  exit -1
}

# Load custom bitnami-utils for the application
if [ -f "/bitnami-utils-custom.sh" ]; then
  . /bitnami-utils-custom.sh
fi
