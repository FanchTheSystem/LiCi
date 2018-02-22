#!/usr/bin/env bash
set -ex

cd package

sha256sum -c ./sha256.to.deploy

if [ -f ./env.to.deploy ]
then
    source ./env.to.deploy
else
    echo "env.to.deploy is missing"
    exit 42
fi

if [ -z ${Target} ]
then
    Target=/tmp
fi

if [ -z ${Tag} ]
then
    Tag=0.0.0
fi


# Todo, check if dir already exist or use a deploy tools
rm -rf ${Target}/${Tag}
mkdir -p ${Target}/${Tag}
cp ${Filename} ${Target}/${Tag}
cd ${Target}/${Tag}
pwd
tar -xf ${Filename}
