#!/usr/bin/env bash
set -ex

# New Branch
# Target
if [ -z ${NewBranch} ]
then
    echo "Need to set NewBranch Var !"
    echo "Example: "
    echo '$> NewBranch=great-branch '$0
    exit 42
fi

# workDir
workDir=$(mktemp -d)
cd ${workDir}
workDir=$(pwd)



# need ssh key configured in ~/.ssh/config and host added to ~/.ssh/known_hosts
# don't know why ~/.ssh/config is not read (maybe because home is a symlink ...)
export GIT_SSH_COMMAND="ssh -i ~/.ssh/id_rsa_gitea"
git clone git@git.libre-informatique.fr:EvE/YmlConf.git -b eve-starter
cd YmlConf

set +e
git checkout ${NewBranch}

if [ $? -eq 0 ]
then
    echo "NewBranch:  ${NewBranch} already exist !"
    echo "Creation Aborded !"
    exit 42
fi
