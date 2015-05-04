#!/bin/bash -e
sv start redis || exit 1
sleep 7
cd /etc/tyk/tyk-dash/tyk-analytics-v${TYK_DASH_VERSION}/
if [[ $ORGANIZATION ]] ; then
    /etc/tyk/tyk-dash/tyk-analytics-v${TYK_DASH_VERSION}/tyk-analytics --neworg --newuser <<HERE
$ORGANIZATION
$FIRST_NAME
$SURNAME
$EMAIL
0
$DASHPASS
$DASHPASS
HERE

else
     /etc/tyk/tyk-dash/tyk-analytics-v${TYK_DASH_VERSION}/tyk-analytics
fi
