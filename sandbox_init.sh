#!/bin/bash

SANDBOX_NAME=$1

[ -z $SANDBOX_NAME ] && echo -e "\e[1;31mUsage\e[0m: $0 repo_name-package_name-arch
repo_name: sisyphus,p8,c8,c8.1,c7,c7.1
arch: x86_64,i586" && exit 1

REPO_NAME=`echo $SANDBOX_NAME | awk -F"-" '{print $1}'`
ARCH=`echo $SANDBOX_NAME | awk -F"-" '{print $3}'`

cd /home/amakeenk/hsh-sandboxes

mkdir $SANDBOX_NAME

cd $SANDBOX_NAME

mkdir hasher tmp

touch apt.conf priorities sources.list

echo "Important:
    basesystem
    altlinux-release-$REPO_NAME
Required:
    apt" > priorities

echo "Dir::Etc::main "/dev/null";
Dir::Etc::parts "/var/empty";
Dir::Etc::sourcelist "/home/amakeenk/hsh-sandboxes/$SANDBOX_NAME/sources.list";
Dir::Etc::pkgpriorities "/home/amakeenk/hsh-sandboxes/$SANDBOX_NAME/priorities";
Dir::Etc::sourceparts "/var/empty";" > apt.conf

PATH_TO_REPO="/ftppool/private/$REPO_NAME/last"

#[ $REPO_NAME == "sis" ] && PATH_TO_REPO="/ftppool/private/sisyphus/last"
#[ $REPO_NAME == "p8" ] && PATH_TO_REPO="/ftppool/private/p8/last"
#[ $REPO_NAME == "c8" ] && PATH_TO_REPO="/ftppool/private/c8/last"
#[ $REPO_NAME == "c7" ] && PATH_TO_REPO="/ftppool/private/c7/last"
#[ $REPO_NAME == "c7.1" ] && PATH_TO_REPO="/ftppool/private/c7.1/last"
#[ $REPO_NAME == "c8.1" ] && PATH_TO_REPO="/ftppool/private/c8.1/last"

if [ $ARCH == "x86_64" ]; then
	echo "rpm  file:$PATH_TO_REPO x86_64 classic
rpm file:$PATH_TO_REPO x86_64-i586 classic
rpm file:$PATH_TO_REPO noarch classic" > sources.list
else
	echo "rpm file:$PATH_TO_REPO i586 classic
rpm file:$PATH_TO_REPO noarch classic" > sources.list
fi
