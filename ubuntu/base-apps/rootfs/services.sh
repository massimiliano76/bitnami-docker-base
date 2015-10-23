#!/bin/bash

start_s6_services() {
    for service in $(ls /etc/services.d); do
        s6-svc -wu -u -T 10000 /var/run/s6/services/$service
        echo "Started $service service."; 
    done
}

stop_s6_services() {
    for service in $(ls /etc/services.d); do
        s6-svc -wd -d -T 10000 /var/run/s6/services/$service
        echo "Stopped $service service."; 
    done
}

print_help() {
    echo "usage: $0 help"
    echo "       $0 (start|stop)"
   
}

if [ "x$1" = "xstart" ]; then
    start_s6_services
elif [ "x$1" = "xstop" ]; then
    stop_s6_services
else
    print_help
fi
