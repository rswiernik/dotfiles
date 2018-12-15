#!/bin/sh

xautolock -exit

# I think the exit takes a small amount of time to complete,
# so if we just attempt to exec right away, we're trying to
# influence an exiting xautolock and we don't get a running
# copy... So we sleep for a second so we can launch a new one!

sleep 1

exec xautolock \
    -locker "slock" \
    -time 5 \
    -corners "+---" \
    -cornerdelay 1 \
    -cornerredelay 1 \
    -cornersize 10 \
    -detectsleep
