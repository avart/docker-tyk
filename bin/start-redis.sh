#!/bin/bash -eu
if [ ! -d /usr/local/redis ]
then
    mkdir -p /usr/local/redis
fi

cd /usr/local/redis
redis-server /etc/redis/redis.conf 
