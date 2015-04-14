#!/bin/bash -e
CONFIG=/etc/tyk/tyk.conf
cd /etc/tyk
tyk --debug --conf=$CONFIG
