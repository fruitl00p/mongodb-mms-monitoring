mongodb-mms-monitoring docker container
==================

A simple mongdb-mms-monitoring agent docker image
(derived from [tianon/mongodb-mms](https://registry.hub.docker.com/u/tianon/mongodb-mms/) )

Running
===
docker run -d -e API_KEY={YOUR_API_KEY} gekkie/mongodb-mms-monitoring

Configuration
===
The agent support various configuration options to be passed via environment variables:

- API_KEY (required) see https://mms.mongodb.com/settings/monitoring-agent
- SERVER (default: https://mms.mongodb.com) The server to which to connect, AKA the MMS BaseUrl
- MUNIN (default: true) Use of the munin-collection for hardware stats
- CHECK_SSL_CERTS (default: true) Should the agent check for valid SSL certificates (what else ;) )