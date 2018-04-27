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

    if [ -z ${Project} ]
    then
        Project=E-venement
    fi

    if [ -z ${Branch} ]
    then
        Branch=master
    fi

    if [ -z ${Suffix} ]
    then
        Suffix=$(echo "${Name}" | sed -e s/-/_/g | sed -e s/'\\.'//g | tr '[:upper:]' '[:lower:]')
    fi

    if [ -z ${Prefix} ]
    then

        Prefix=$(echo "/${Project}/${Name}/${Branch}" | sed -e s/-/_/g | sed -e s/'\\.'//g | tr '[:upper:]' '[:lower:]')
    fi

    touch .prefix
    echo "Prefix=${Prefix}" >> .prefix
    echo "Suffix=${Suffix}" >> .prefix
    cat .prefix
fi
