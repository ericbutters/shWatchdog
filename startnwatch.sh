#!/bin/sh

kill_processes () {
    pidfiles=$(ls /tmp/carplay_pids)
    for p in $pidfiles; do
          pid=$(cat /tmp/carplay_pids/$p)
          kill -9 $pid
    done
} #kill_processes

start_processes () {
    # create a directory for our pid files
    mkdir /tmp/carplay_pids
    # start the applications, name pid files like process.
    /tmp/1.sh &
    echo $! > /tmp/carplay_pids/1sh.pid
    /tmp/1.sh &
    echo $! > /tmp/carplay_pids/11sh.pid
} #start_processes

# start all carplay components
start_processes

# watch the processes
while [ -d "/tmp/carplay_pids/" ]; do
    pidfiles=$(ls /tmp/carplay_pids)
    for p in $pidfiles; do
    pid=$(cat /tmp/carplay_pids/$p)
    isRunning=$(ps aux | grep -v grep | grep $pid)
    if [ "$isRunning" == "" ]; then
        # kill all carplay components and restart them
        echo "need restart of" $p
        kill_processes
        sleep 1
        start_processes
    fi
    done
    sleep 1
done
