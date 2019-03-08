#!/bin/bash

SANDBOX_NAME=$1

[ -z $SANDBOX_NAME ] && echo -e "\e[1;31mUsage\e[0m: $0 repo_name-package_name-arch
repo_name: sis,p8
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

[ $REPO_NAME == "sis" ] && PATH_TO_REPO="http://ftp.altlinux.org/pub/distributions/ALTLinux/Sisyphus"
[ $REPO_NAME == "p8" ] && PATH_TO_REPO="http://ftp.altlinux.org/pub/distributions/ALTLinux/p8/branch"

if [ $ARCH == "x86_64" ]; then
cat > sources.list <<EOF
rpm ${PATH_TO_REPO} x86_64 classic
rpm ${PATH_TO_REPO} x86_64-i586 classic
rpm ${PATH_TO_REPO} noarch classic

#rpm-dir file:/local_repo/p8 x86_64 dir
EOF
else
cat > sources.list <<EOF
rpm ${PATH_TO_REPO} i586 classic
rpm ${PATH_TO_REPO} noarch classic
EOF
fi
