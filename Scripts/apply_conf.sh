#!/usr/bin/env bash
set -ex

# Target
if [ -z ${Target} ]
then
    Target=/tmp
fi
mkdir -p ${Target}
cd ${Target}
Target=$(pwd) #if previous dir was a relative or symbolic path

# Branch
if [ -z ${Branch} ]
then
    Branch=eve-standard
fi

workDir=$(mktemp -d)
cd ${workDir}
workDir=$(pwd)

mkdir -p YmlConf/

# need ssh key configured in ~/.ssh/config and host added to ~/.ssh/known_hosts
# don't know why ~/.ssh/config is not read (maybe because home is a symlink ...)
export GIT_SSH_COMMAND="ssh -i ~/.ssh/id_rsa_gitea"
git clone git@git.libre-informatique.fr:EvE/YmlConf.git -b ${Branch}

cp -r YmlConf/* ${Target}/

rm -rf ${workDir}
