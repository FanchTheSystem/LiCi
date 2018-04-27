#!/usr/bin/env bash
set -ex


if [ -z ${Target} ]
then
    Target=/tmp
fi
mkdir -p ${Target}
cd ${Target}
Target=$(pwd) #if previous workDir was a relative or symbolic path

if [ -f .prefix ]
then
    cat .prefix
else

    if [ -z ${Name} ]
    then
        Name=dev
    fi
    Name=$(echo "${Name}" | sed s/'\W'//g | tr '[:upper:]' '[:lower:]')

    if [ -z ${Project} ]
    then
        Project=E-venement
    fi
    Project=$(echo "${Project}" | sed s/'\W'//g | tr '[:upper:]' '[:lower:]')

    if [ -z ${Branch} ]
    then
        Branch=master
    fi
    Branch=$(echo "${Branch}" | sed s/'\W'//g | tr '[:upper:]' '[:lower:]')

    if [ -z ${Suffix} ]
    then
        Suffix="${Name}"
    fi

    if [ -z ${Prefix} ]
    then

        Prefix="/${Project}/${Name}/${Branch}"
    fi

    touch .prefix
    echo "Prefix=${Prefix}" >> .prefix
    echo "Suffix=${Suffix}" >> .prefix
    cat .prefix
fi
