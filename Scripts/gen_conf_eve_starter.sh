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

# Should have run check_if_conf_branch_exist.sh before this !
git checkout -b ${NewBranch}




# Default eve-starter value

if [ -z ${AboutAddress} ]
then
    AboutAddress='22 acacia avenue
RM12 4EN Hornchurch
England'
fi
if [ -z ${AboutCountry} ]
then
    AboutCountry='WonderLand'
fi
if [ -z ${AboutLogo} ]
then
    AboutLogo='../private/images/logo.png'
fi
if [ -z ${AboutName} ]
then
    AboutName='Hari Seldon'
fi
if [ -z ${AboutWebsite} ]
then
    AboutWebsite='https://www.libre-informatique.fr/'
fi
if [ -z ${CardsExtra} ]
then
    CardsExtra="${AboutName} ${AboutWebsite}
${AboutAddress}
${AboutCountry}"
fi
if [ -z ${EtickettingSalt} ]
then
    EtickettingSalt=$(shuf -i 10000-1000000 -n 1 | sha256sum | cut -f1 -d' ')
fi
if [ -z ${InformationsTitle} ]
then
    InformationsTitle=${AboutName}
fi
if [ -z ${OptionsLayout} ]
then
    OptionsLayout='list'
fi
if [ -z ${OptionsTheme} ]
then
    OptionsTheme='dark'
fi
if [ -z ${SellerAddress} ]
then
    SellerAddress=${AboutAddress}
fi
if [ -z ${SellerCity} ]
then
    SellerCity='City Of Ember'
fi
if [ -z ${SellerCountry} ]
then
    SellerCountry=${AboutCountry}
fi
if [ -z ${SellerLogo} ]
then
    SellerLogo=${AboutLogo}
fi
if [ -z ${SellerName} ]
then
    SellerName=${AboutName}
fi
if [ -z ${SellerPostalcode} ]
then
    SellerPostalcode='42'
fi
if [ -z ${TextsEmailConfirmation} ]
then
    TextsEmailConfirmation="${SellerName}
${SellerPostalcode} ${SellerCity}
${SellerWebsite}"
fi
if [ -z ${TicketsLicences} ]
then
    TicketsLicences='350970'
fi

#/eve/about/client/address
#/eve/about/client/country
#/eve/about/client/logo
#/eve/about/client/name
#/eve/about/client/website
#/eve/cards/extra
#/eve/eticketting/salt
#/eve/informations/title
#/eve/options/layout
#/eve/options/theme
#/eve/seller/address
#/eve/seller/city
#/eve/seller/country
#/eve/seller/logo
#/eve/seller/name
#/eve/seller/postalcode
#/eve/texts/email_confirmation
#/eve/tickets/licences





cd
rm -rf ${workDir}
