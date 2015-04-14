#!/bin/bash -eu
if [ ! -d /usr/local/redis ]
then
    mkdir -p /usr/local/redis
    chown api:secure /usr/local/redis
fi

cd /usr/local/redis
sleep 1
exec /sbin/setuser api redis-server /etc/redis/redis.conf
