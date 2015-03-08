#!/bin/bash
set -xe

/etc/init.d/mongod start
service redis-server start
service ssh start
service rsyslog start
service gandalf-server start
service archive-server start
service hipache start
service tsuru-server-api start

export DOCKER_DAEMON_ARGS="-H 127.0.0.1:2375 -H unix://var/run/docker.sock"
/usr/local/bin/wrapdocker
/configure.sh

[[ $1 ]] && exec "$@"

