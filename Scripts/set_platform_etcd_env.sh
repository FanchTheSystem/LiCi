#!/usr/bin/env bash
set -ex

export ETCDCTL_API=3
# Branch


if [ -z ${Suffix} ]
then
    if [ -z ${Name} ]
    then
        Name=master
    fi
    Suffix=$(echo $Name|sed -e s/-/_/g|sed -e s/ //g|tr '[:upper:]' '[:lower:]')
fi

if [ -z ${Prefix} ]
then
    Prefix="/platform/dev/"$Suffix
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
apacheurl=$($ETCDCTLCMD get /default/apache-php/7.1/servername --print-value-only $ETCDENDPOINT)

# set postgres env
$ETCDCTLCMD put $Prefix/postgres/hostname $postgreshost $ETCDENDPOINT
$ETCDCTLCMD put $Prefix/postgres/root/username $postgresuser $ETCDENDPOINT
$ETCDCTLCMD put $Prefix/postgres/root/password $postgrespass $ETCDENDPOINT

$ETCDCTLCMD put $Prefix/postgres/user/dbname sil_db_$Suffix $ETCDENDPOINT
$ETCDCTLCMD put $Prefix/postgres/user/username sil_user_$Suffix $ETCDENDPOINT
$ETCDCTLCMD put $Prefix/postgres/user/password sil_password_$Suffix $ETCDENDPOINT

# set elastic env
$ETCDCTLCMD put $Prefix/elastic/hostname $elastichost $ETCDENDPOINT
$ETCDCTLCMD put $Prefix/elastic/indexalias sil_$Suffix $ETCDENDPOINT

# not used on deploy, may be need for conf
$ETCDCTLCMD put $Prefix/selenium/hostname 127.0.0.1 $ETCDENDPOINT

# set symfony env
$ETCDCTLCMD put $Prefix/symfony/env prod $ETCDENDPOINT # maybe put this in env variable (or not)
# not used on deploy, may be need for conf
$ETCDCTLCMD put $Prefix/symfony/addr '127.0.0.1:8042' $ETCDENDPOINT

$ETCDCTLCMD put $Prefix/sylius/channelurl $apacheurl $ETCDENDPOINT

$ETCDCTLCMD get --prefix $Prefix $ETCDENDPOINT

#confd -onetime -backend etcdv3 -node http://${ETCDHOST}:2379 -confdir ./etc/confd -log-level debug -prefix $Prefix
