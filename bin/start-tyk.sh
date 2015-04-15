#!/bin/bash -e
CONFIG=/etc/tyk/tyk.conf
sv start redis || exit 1
sleep 5
#DASH_CONFIG=/etc/tyk/tyk-dash/tyk-analytics-v${TYK_DASH_VERSION}/tyk_analytics.conf
#[ -z "$DB_PORT_6379_TCP_ADDR" ] && { echo "Redis not linked"; exit 255; }
#sed -i "s/REDIS_HOST/$DB_PORT_6379_TCP_ADDR/" $CONFIG
#sed -i "s/REDIS_HOST/$DB_PORT_6379_TCP_ADDR/" $DASH_CONFIG
cd /etc/tyk
tyk --debug --conf=$CONFIG
