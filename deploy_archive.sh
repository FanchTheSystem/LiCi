#!/usr/bin/env bash
set -ex

Name=Platform
workDir=$(mktemp -d) #mkdir ${workDir}
cd ${workDir}
workDir=$(pwd) #if previous workDir was a relative or symbolic path
if [ -z ${Target} ]
then
    Target=/tmp
fi
cd ${Target}
Target=$(pwd) #if previous workDir was a relative or symbolic path
if [ -z ${Source} ]
then
    Source=${HOME}/public_html/repo/${Name}
fi
cd ${Source}
Source=$(pwd) #if previous workDir was a relative or symbolic path
Finename=$(cat ${Name}_Latest.txt)
sha256sum -c ${Name}_Latest.sha256

cp ${Source}/${Filename} ${workDir}/

cd ${workDir}
tar -xf ${Filename}
if [ -z ${Tag} ]
then
    Tag=$(cat Tag.txt)
fi
if [ -z ${Version} ]
then
    Version=$(cat Version.txt)
fi
if [ ${Version} = ${Tag} ]
then
    Target=${Target}/${Tag}
else
    Target=${Target}/$(echo ${Version}|sed -e s/${Tag}/Dev/g)
fi
# Todo, check if dir already exist or use a deploy tools
if [ -d ${Target} ]
then
    mv ${Target} ${Target}$(date +'%Y%m%d%H%M%S')
fi

mv ${workDir} ${Target}
chmod -R 755 ${Target}
