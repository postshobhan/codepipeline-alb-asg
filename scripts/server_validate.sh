#!/bin/bash

while [ true ]
do
    if [ "$(curl -s http://localhost:8080/actuator/health)" = '{"status":"UP"}' ]
    then
        echo "server is running fine"
        exit 0
    else
        echo "check server is running?"
        sleep 3s
    fi
done