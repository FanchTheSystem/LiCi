#!/usr/bin/env bash
set -ex

export ETCDCTL_API=3
# Branch


if [ -z ${Prefix} ]
then
    if [ -z ${Branch} ]
    then
        Branch=master
    fi
    Prefix="/platform/dev/"$(echo $Branch|sed -e s/-/_/g|tr '[:upper:]' '[:lower:]')
fi

if [ -z "$ETCDHOST" ]
then
    ETCDHOST="etcd.host"
fi
ETCDENDPOINT="--endpoints=http://${ETCDHOST}:2379"

if [ -z "$ETCDCTLCMD" ]
then
    ETCDCTLCMD="docker exec $ETCDHOST etcdctl "
fi

# check
$ETCDCTLCMD get --prefix '/default' $ETCDENDPOINT

# get postgres default
postgreshost=$($ETCDCTLCMD get /default/postgres/hostname --print-value-only $ETCDENDPOINT)
postgresuser=$($ETCDCTLCMD get /default/postgres/root/username --print-value-only $ETCDENDPOINT)
postgrespass=$($ETCDCTLCMD get /default/postgres/root/password --print-value-only $ETCDENDPOINT)
# TODO add a check default cnx with psql

# get elastic default
elastichost=$($ETCDCTLCMD get /default/elastic/hostname --print-value-only $ETCDENDPOINT)

# get apache default (for php 7.1)
apacheurl=$($ETCDCTLCMD get /default/apache/7.1/servername --print-value-only $ETCDENDPOINT)

# set postgres env
$ETCDCTLCMD put $prefix/postgres/hostname $postgreshost $ETCDENDPOINT
$ETCDCTLCMD put $prefix/postgres/root/username $postgresuser $ETCDENDPOINT
$ETCDCTLCMD put $prefix/postgres/root/password $postgrespass $ETCDENDPOINT

$ETCDCTLCMD put $prefix/postgres/user/dbname sil_db_$prefix $ETCDENDPOINT
$ETCDCTLCMD put $prefix/postgres/user/username sil_user_$prefix $ETCDENDPOINT
$ETCDCTLCMD put $prefix/postgres/user/password sil_password_$prefix $ETCDENDPOINT

# set elastic env
$ETCDCTLCMD put $prefix/elastic/hostname $elastichost $ETCDENDPOINT
$ETCDCTLCMD put $prefix/elastic/indexalias sil_$prefix $ETCDENDPOINT

# set symfony env
$ETCDCTLCMD put $prefix/symfony/env test $ETCDENDPOINT # maybe put this in env variable (or not)
# not used on deploy, may be need for conf
$ETCDCTLCMD put $prefix/symfony/addr '127.0.0.1:8042' $ETCDENDPOINT

$ETCDCTLCMD put $prefix/sylius/channelurl $apacheurl $ETCDENDPOINT

$ETCDCTLCMD get --prefix $prefix $ETCDENDPOINT

#confd -onetime -backend etcdv3 -node http://${ETCDHOST}:2379 -confdir ./etc/confd -log-level debug -prefix $prefix
