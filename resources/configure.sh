#!/bin/bash
set -e

: ${SERVER:=https://mms.mongodb.com}
: ${MUNIN:=true}
: ${CHECK_SSL_CERTS:=true}

if [ ! "$API_KEY" ]; then
	{
		echo 'error: API_KEY was not specified'
		echo 'try something like: docker run -e API_KEY=... ...'
		echo '(see https://mms.mongodb.com/settings/monitoring-agent for your mms ApiKey)'
		echo
		echo 'Other optional variables:'
		echo ' - SERVER='"$SERVER"
		echo ' - MUNIN='"$MUNIN"
		echo ' - CHECK_SSL_CERTS='"$CHECK_SSL_CERTS"
	} >&2
	exit 1
fi

# "sed -i" can't operate on the file directly, and it tries to make a copy in the same directory, which our user can't do
config_tmp="$(mktemp)"
cat /etc/mongodb-mms/monitoring-agent.config > "$config_tmp"

set_config() {
	key="$1"
	value="$2"
	sed_escaped_value="$(echo "$value" | sed 's/[\/&]/\\&/g')"
	sed -ri "s/^($key)[ ]*=.*$/\1 = $sed_escaped_value/" "$config_tmp"
}

set_config mmsApiKey "$API_KEY"
set_config mmsBaseUrl "$SERVER"
set_config enableMunin "$MUNIN"
set_config sslRequireValidServerCertificates "$CHECK_SSL_CERTS"

cat "$config_tmp" > /etc/mongodb-mms/monitoring-agent.config
rm "$config_tmp"

exec "$@"