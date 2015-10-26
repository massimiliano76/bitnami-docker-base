#!/bin/bash
export TERM=xterm
colors256() {
        local c i j

        printf "Standard 16 colors\n"
        for ((c = 0; c < 17; c++)); do
                printf "|%s%3d%s" "$(tput setaf "$c")" "$c" "$(tput sgr0)"
        done
        printf "|\n\n"

        printf "Colors 16 to 231 for 256 colors\n"
        for ((c = 16, i = j = 0; c < 232; c++, i++)); do
                printf "|"
                ((i > 5 && (i = 0, ++j))) && printf " |"
                ((j > 5 && (j = 0, 1)))   && printf "\b \n|"
                printf "%s%3d%s" "$(tput setaf "$c")" "$c" "$(tput sgr0)"
        done
        printf "|\n\n"

        printf "Greyscale 232 to 255 for 256 colors\n"
        for ((; c < 256; c++)); do
                printf "|%s%3d%s" "$(tput setaf "$c")" "$c" "$(tput sgr0)"
        done
        printf "|\n"
}

#colors256

blackf=$(tput setaf 0)
blackb=$(tput setab 0)
redf=$(tput setaf 1)
redb=$(tput setab 1)
greenf=$(tput setaf 2)
greenb=$(tput setab 2)
yellowf=$(tput setaf 3)
yellowb=$(tput setab 3)
bluef=$(tput setaf 4)
blueb=$(tput setab 4)
purplef=$(tput setaf 5)
purpleb=$(tput setab 5)
cyanf=$(tput setaf 6)
cyanb=$(tput setab 6)
whitef=$(tput setaf 7)
whiteb=$(tput setab 7)
reset=$(tput op)

PREFIX=/opt/bitnami

case $1 in
apache)
    logfile=$PREFIX/apache2/logs/error_log
    index="$redf[$1]$reset "
    ;;
mysql | mariadb)
    logfile=$PREFIX/mysql/data/mysqld.log
    index="$yellowf[$1]$reset "
    ;;
php | php-fpm)
    logfile=$PREFIX/php/var/log/php-fpm.log
    index="$bluef[$1]$reset "
    ;;
*) exit
esac

tail -F $logfile | sed -e "s/^\(.*\)$/$index \1/"
