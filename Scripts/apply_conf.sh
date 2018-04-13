#!/usr/bin/env bash
set -ex

# Target
if [ -z ${Target} ]
then
    Target=/tmp
fi
mkdir -p ${Target}
cd ${Target}
Target=$(pwd) #if previous workDir was a relative or symbolic path

# Branch
if [ -z ${Branch} ]
then
    Branch=eve-standard
fi

workDir=$(mktemp -d)
cd ${workDir}
workDir=$(pwd) #if previous workDir was a relative or symbolic path

mkdir -p YmlConf/

# need ssh key configured
git clone git@git.libre-informatique.fr:EvE/YmlConf.git -b ${Branch}

cp -r YmlConf/* ${Target}/

rm -rf ${workDir}
