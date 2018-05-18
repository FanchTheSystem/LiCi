#!/usr/bin/env bash
set -e #x

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

# small security check if branch start with eve-starter- because we don't want to drop any other branch
if [ ${NewBranch:0:12} = "eve-starter-" ]
then
    # need ssh key configured in ~/.ssh/config and host added to ~/.ssh/known_hosts
    # don't know why ~/.ssh/config is not read (maybe because home is a symlink ...)
    export GIT_SSH_COMMAND="ssh -i ~/.ssh/id_rsa_gitea"
    git clone git@git.libre-informatique.fr:EvE/YmlConf.git -b eve-starter
    cd YmlConf

    git push origin --delete  ${NewBranch}
fi
