#!/usr/bin/env bash
set -ex

if [ -z ${Project} ]
then
    Project=Platform
fi

if [ -z ${Name} ]
then
    Name=master
fi

if [ -z ${Branch} ]
then
    Branch=master
fi

if [ -z ${LIREPOPATH} ]
then
    LIREPOPATH=/tmp
fi

# Source
if [ -z ${Target} ]
then
    Target=${LIREPOPATH}/private/${Project}
fi
mkdir -p ${Target}
cd ${Target}
Target=$(pwd) #if previous workDir was a relative or symbolic path

# Target
if [ -d ${Source} ]
then
    cd ${Source}

    Filename=${Target}/${Project}_${Name}_${Branch}.tar.gz

    rm -f ${Filename}

    tar -czf ${Filename} ./*

    sha256sum ${Filename} > ${Filename}.sha256.txt
# -h

fi
