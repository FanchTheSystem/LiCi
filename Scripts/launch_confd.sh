#!/usr/bin/env bash
set -ex

if [ -f .prefix ]
then
    source .prefix
else
    echo "Please run set_prefix.sh before this script"
    exit 42
fi

if [ -z "$CONFDHOST" ]
then
    CONFDHOST="confd.host"
fi

if [ -z "$ETCDHOST" ]
then
    ETCDHOST="etcd.host"
fi

if [ -z "${DockerTarget}" ]
then
    echo "Env Variable DockerTarget is mandatory, please set it"
    exit 42
fi


docker exec -u jenkins:www-data -w ${DockerTarget} ${CONFDHOST} confd -onetime -backend etcdv3 -node http://${ETCDHOST}:2379 -confdir ./etc/confd -log-level debug -prefix ${Prefix}
