#!/bin/bash

set -e

# Start rsyslogd
# We are doing this to enable Rsyslogd to listen on tcp/514 and udp/514
rsyslogd

# Add logstash as command if needed
if [ "${1:0:1}" = '-' ]; then
	set -- logstash "$@"
fi

# Run as user "logstash" if the command is "logstash"
if [ "$1" = 'logstash' ]; then
	set -- gosu logstash "$@"
fi

exec "$@"
