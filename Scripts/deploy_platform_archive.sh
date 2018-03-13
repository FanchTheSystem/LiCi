#!/usr/bin/env bash
set -ex

# Name
if [ -z ${Name} ]
then
    Name=Platform
fi

# Branch
if [ -z ${Branch} ]
then
    Branch=master
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
    Source=${HOME}/public_html/repo/${Name}
fi
cd ${Source}
Source=$(pwd) #if previous workDir was a relative or symbolic path

#Filename
if [ -z ${Filename} ]
then
    Filename=${Name}_${Branch}.tar.gz
fi

sha256sum -c ${Filename}.sha256.txt

cp ${Source}/${Filename} ${workDir}/

cd ${workDir}
tar -xf ${Filename}


Target=${Target}/${Branch}

# Todo, check if dir already exist or use a deploy tools
#if [ -d ${Target} ]
#then
#    mv ${Target} ${Target}$(date +'%Y%m%d%H%M%S')
#fi
mkdir -p ${Target}
cp -rp ${workDir}/* ${Target}/

rm -rf ${workDir}
