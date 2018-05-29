#!/usr/bin/env bash
set -ex

if [ -f ${Target}/.prefix ]
then
    source ${Target}/.prefix
else
    echo "Please run set_prefix.sh before this script"
    exit 42
fi

export ETCDCTL_API=3
# Branch

if [ -z $PhpVersion ]
then
    PhpVersion=7.1
fi

if [ -z $ApacheTargetPath ]
then
    # todo : should use the server root or something else (or not)
    ApacheTargetPath=/tmp
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

# get postgres default
postgreshost=$($ETCDCTLCMD get /default/postgres/hostname --print-value-only $ETCDENDPOINT)
postgresuser=$($ETCDCTLCMD get /default/postgres/root/username --print-value-only $ETCDENDPOINT)
postgrespass=$($ETCDCTLCMD get /default/postgres/root/password --print-value-only $ETCDENDPOINT)
# TODO add a check default cnx with psql

# get elastic default
elastichost=$($ETCDCTLCMD get /default/elastic/hostname --print-value-only $ETCDENDPOINT)

# get apache default (for php $PhpVersion)
apacheurl=$($ETCDCTLCMD get /default/apache-php/$PhpVersion/servername --print-value-only $ETCDENDPOINT)
# apache target path
$ETCDCTLCMD put $Prefix/apache/target/path $ApacheTargetPath $ETCDENDPOINT # maybe put this in env variable (or not)
# todo: should get this path from etcd in other script like deploy or apply config


# set postgres env
$ETCDCTLCMD put $Prefix/postgres/hostname $postgreshost $ETCDENDPOINT
$ETCDCTLCMD put $Prefix/postgres/root/username $postgresuser $ETCDENDPOINT
$ETCDCTLCMD put $Prefix/postgres/root/password $postgrespass $ETCDENDPOINT

$ETCDCTLCMD put $Prefix/postgres/user/dbname $Suffix $ETCDENDPOINT
$ETCDCTLCMD put $Prefix/postgres/user/username $Suffix $ETCDENDPOINT
$ETCDCTLCMD put $Prefix/postgres/user/password $(openssl rand -hex 4) $ETCDENDPOINT

# set elastic env
$ETCDCTLCMD put $Prefix/elastic/hostname $elastichost $ETCDENDPOINT
$ETCDCTLCMD put $Prefix/elastic/indexalias $Suffix $ETCDENDPOINT

# not used on deploy, may be need for conf
$ETCDCTLCMD put $Prefix/selenium/hostname 127.0.0.1 $ETCDENDPOINT

# set symfony env
$ETCDCTLCMD put $Prefix/symfony/env prod $ETCDENDPOINT # maybe put this in env variable (or not)
# not used on deploy, may be need for conf
$ETCDCTLCMD put $Prefix/symfony/addr '127.0.0.1:8042' $ETCDENDPOINT

$ETCDCTLCMD get --prefix $Prefix $ETCDENDPOINT
