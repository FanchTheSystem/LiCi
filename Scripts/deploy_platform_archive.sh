#!/usr/bin/env bash
set -ex

# Name
if [ -z ${Project} ]
then
    Project=Platform
fi

# Branch
if [ -z ${Branch} ]
then
    Branch=master
fi

# Name
if [ -z ${Name} ]
then
    Name=${Branch}
fi

# WorkDir
workDir=$(mktemp -d) #mkdir ${workDir}
cd ${workDir}
workDir=$(pwd) #if previous workDir was a relative or symbolic path

# Target
if [ -z ${Target} ]
then
    Target=/tmp
fi
mkdir -p ${Target}
cd ${Target}
Target=$(pwd) #if previous workDir was a relative or symbolic path

# Source
if [ -z ${Source} ]
then
    Source=${HOME}/public_html/repo/${Project}
fi
cd ${Source}
Source=$(pwd) #if previous workDir was a relative or symbolic path

#Filename
if [ -z ${Filename} ]
then
    Filename=${Project}_${Branch}.tar.gz
fi

sha256sum -c ${Filename}.sha256.txt

cp ${Source}/${Filename} ${workDir}/

cd ${workDir}
tar -xf ${Filename}


Target=${Target}/${Name}

# Todo, check if dir already exist or use a deploy tools
#if [ -d ${Target} ]
#then
#    mv ${Target} ${Target}$(date +'%Y%m%d%H%M%S')
#fi
mkdir -p ${Target}
cp -r ${workDir}/* ${Target}/

rm -rf ${workDir}
