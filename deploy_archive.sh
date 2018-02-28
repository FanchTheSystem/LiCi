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
chmod -R 755 ${Target}



# Url
if [ -z ${Url} ]
then
    Url=127.0.0.1
fi

# TODO, should use etcd or other like that tool
echo "
DBHOST=postgres.host
DBROOTUSER=postgres
DBROOTPASSWORD=postgres24
DBAPPNAME=sil_db_${Branch}
DBAPPUSER=sil_user_${Branch}
DBAPPPASSWORD=sil_password

ELHOST=elk.host
ELALIAS=sil_${Branch}

CHANNELURL=${Url}
" > ${Target}/.env


cat ${Target}/.env
