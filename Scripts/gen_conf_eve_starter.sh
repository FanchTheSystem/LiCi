#!/usr/bin/env bash
set -ex

scriptdir=$(pwd)/Scripts
# New Branch
# Target
if [ -z ${NewBranch} ]
then
    echo "Need to set NewBranch Var !"
    echo "Example: "
    echo '$> NewBranch=great-branch '$0
    exit 42
fi

if [ -z "${TMPDIR}" ]
then
    TMPDIR=$HOME/public_html/tmp
fi
mkdir -p ${TMPDIR}

# workDir
workDir=$(mktemp -d -p $TMPDIR)
cd ${workDir}

# needed as we use confd in docker with /home/jenkins/public_html mount
# @todo should find a cleaner way to do this
DockerTarget=/home/jenkins/public_html/tmp/$(basename $workDir)


# need ssh key configured in ~/.ssh/config and host added to ~/.ssh/known_hosts
# don't know why ~/.ssh/config is not read (maybe because home is a symlink ...)
export GIT_SSH_COMMAND="ssh -i ~/.ssh/id_rsa_gitea"
git clone git@git.libre-informatique.fr:EvE/YmlConf.git -b eve-starter ${workDir}


Target=$workDir Name='eve-starter' Branch=${NewBranch} $scriptdir/set_prefix.sh
source .prefix

# Should have run check_if_conf_branch_exist.sh before this !
git checkout -b ${NewBranch}

# Default eve-starter value
# @todo automate the add or remove of this list of variable

if [ -z ${AboutAddress} ]
then
    AboutAddress='22 acacia avenue RM12 4EN Hornchurch England'
fi

if [ -z ${AboutCountry} ]
then
    AboutCountry='WonderLand'
fi

if [ -z ${AboutLogo} ]
then
    AboutLogo='../private/images/logo.png'
fi

if [ -z ${AboutName} ]
then
    AboutName='Hari Seldon'
fi

if [ -z ${AboutWebsite} ]
then
    AboutWebsite='https://www.libre-informatique.fr/'
fi

if [ -z ${CardsExtra} ]
then
    CardsExtra="${AboutName} ${AboutWebsite} ${AboutAddress} ${AboutCountry}"
fi

if [ -z ${EtickettingSalt} ]
then
    EtickettingSalt=$(shuf -i 10000-1000000 -n 1 | sha256sum | cut -f1 -d' ')
fi

if [ -z ${InformationsTitle} ]
then
    InformationsTitle=${AboutName}
fi

if [ -z ${OptionsLayout} ]
then
    OptionsLayout='list'
fi

if [ -z ${OptionsTheme} ]
then
    OptionsTheme='dark'
fi

if [ -z ${SellerAddress} ]
then
    SellerAddress=${AboutAddress}
fi

if [ -z ${SellerCity} ]
then
    SellerCity='City Of Ember'
fi

if [ -z ${SellerCountry} ]
then
    SellerCountry=${AboutCountry}
fi

if [ -z ${SellerLogo} ]
then
    SellerLogo=${AboutLogo}
fi

if [ -z ${SellerName} ]
then
    SellerName=${AboutName}
fi

if [ -z ${SellerPostalcode} ]
then
    SellerPostalcode='42'
fi

if [ -z ${TextsEmailConfirmation} ]
then
    TextsEmailConfirmation="${SellerName} ${SellerPostalcode} ${SellerCity} ${SellerWebsite}"
fi

if [ -z ${TicketsLicences} ]
then
    TicketsLicences='350970'
fi

if [ -z ${UserPassword} ]
then
    UserPassword='42'
fi

if [ -z ${PayboxId} ]
then
    PayboxId='1'
fi

if [ -z ${PayboxKey} ]
then
     PayboxKey='0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF'
fi

if [ -z ${PayboxRank} ]
then
     PayboxRank='32'
fi

if [ -z ${PayboxSite} ]
then
     PayboxSite='1999888'
fi

if [ -z ${PayboxUrl} ]
then
    PayboxUrl='[https://preprod-tpeweb.paybox.com/, https://preprod-tpeweb1.paybox.com/]'
fi

if [ -z ${PayboxUri} ]
then
    PayboxUri='cgi/MYchoix_pagepaiement.cgi'
fi

export ETCDCTL_API=3

if [ -z "$ETCDHOST" ]
then
    ETCDHOST="etcd.host"
fi
ETCDENDPOINT="--endpoints=http://${ETCDHOST}:2379"

if [ -z "$ETCDCTLCMD" ]
then
    ETCDCTLCMD="docker exec $ETCDHOST etcdctl "
fi

$ETCDCTLCMD version

$ETCDCTLCMD put $Prefix/eve/about/client/address "${AboutAddress}" $ETCDENDPOINT
$ETCDCTLCMD put $Prefix/eve/about/client/country "${AboutCountry}" $ETCDENDPOINT
$ETCDCTLCMD put $Prefix/eve/about/client/logo "${AboutLogo}" $ETCDENDPOINT
$ETCDCTLCMD put $Prefix/eve/about/client/name "${AboutName}" $ETCDENDPOINT
$ETCDCTLCMD put $Prefix/eve/about/client/website "${AboutWebsite}" $ETCDENDPOINT
$ETCDCTLCMD put $Prefix/eve/cards/extra "${CardsExtra}" $ETCDENDPOINT
$ETCDCTLCMD put $Prefix/eve/eticketting/salt "${EtickettingSalt}" $ETCDENDPOINT
$ETCDCTLCMD put $Prefix/eve/informations/title  "${InformationsTitle}" $ETCDENDPOINT
$ETCDCTLCMD put $Prefix/eve/options/layout "${OptionsLayout}" $ETCDENDPOINT
$ETCDCTLCMD put $Prefix/eve/options/theme "${OptionsTheme}" $ETCDENDPOINT
$ETCDCTLCMD put $Prefix/eve/seller/address "${SellerAddress}" $ETCDENDPOINT
$ETCDCTLCMD put $Prefix/eve/seller/city "${SellerCity}" $ETCDENDPOINT
$ETCDCTLCMD put $Prefix/eve/seller/country "${SellerCountry}" $ETCDENDPOINT
$ETCDCTLCMD put $Prefix/eve/seller/logo "${SellerLogo}" $ETCDENDPOINT
$ETCDCTLCMD put $Prefix/eve/seller/name "${SellerName}" $ETCDENDPOINT
$ETCDCTLCMD put $Prefix/eve/seller/postalcode "${SellerPostalcode}" $ETCDENDPOINT
$ETCDCTLCMD put $Prefix/eve/texts/email_confirmation "${TextsEmailConfirmation}" $ETCDENDPOINT
$ETCDCTLCMD put $Prefix/eve/tickets/licences "${TicketsLicences}" $ETCDENDPOINT
$ETCDCTLCMD put $Prefix/eve/user/password "${UserPassword}" $ETCDENDPOINT
$ETCDCTLCMD put $Prefix/paybox/id "${PayboxId}" $ETCDENDPOINT
$ETCDCTLCMD put $Prefix/paybox/key "${PayboxKey}" $ETCDENDPOINT
$ETCDCTLCMD put $Prefix/paybox/rank "${PayboxRank}" $ETCDENDPOINT
$ETCDCTLCMD put $Prefix/paybox/site "${PayboxSite}" $ETCDENDPOINT
$ETCDCTLCMD put $Prefix/paybox/url "${PayboxUrl}" $ETCDENDPOINT
$ETCDCTLCMD put $Prefix/paybox/uri "${PayboxUri}" $ETCDENDPOINT

$ETCDCTLCMD get --prefix $Prefix $ETCDENDPOINT

DockerTarget=${DockerTarget} Target=${workDir} CONFDDIR="./etc/confd.for.branch.creation" $scriptdir/launch_confd.sh

git status
git add apps config
git commit -m "[EveStarter] Branch Creation"
git push -u origin $NewBranch

cd
rm -rf ${workDir}
