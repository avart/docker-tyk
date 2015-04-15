#!/bin/bash -e
sv start redis || exit 1
sleep 7
cd /etc/tyk/tyk-dash/tyk-analytics-v${TYK_DASH_VERSION}/
/etc/tyk/tyk-dash/tyk-analytics-v${TYK_DASH_VERSION}/tyk-analytics --neworg --newuser <<HERE
Stickybit
Emmanuel
Nyberg
emmanuel@stickybit.se
0
kanin26
kanin26
HERE


