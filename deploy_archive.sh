#!/usr/bin/env bash
set -ex



sha256sum -c *.sha256


if [ -z ${Target} ]
then
    Target=/tmp
fi

workDir=/tmp/work


mkdir ${workDir}
cp ${Filename} ${workDir}/
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

cd -

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


#mkdir -p ${Target}/${Tag}
#cp ${Filename} ${Target}/${Tag}
#cd ${Target}/${Tag}
#pwd
