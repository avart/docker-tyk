#!/bin/bash
sv start redis || exit 1
sleep 8
cd /etc/tyk/tyk-dash/tyk-analytics-v${TYK_DASH_VERSION}/host-manager/
/etc/tyk/tyk-dash/tyk-analytics-v${TYK_DASH_VERSION}/host-manager/tyk-host-manager
