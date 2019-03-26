#!/bin/sh -e

sandbox_name=$1

[ -z ${sandbox_name} ] && echo -e "\e[1;31mUsage\e[0m: $0 repo_name-package_name-repo_arch
repo_name: sisyphus,p8,c7,c7.1,c8,c8.1
repo_arch: x86_64,i586" && exit 1

repo_name=$(echo ${sandbox_name} | awk -F"-" '{print $1}')
repo_arch=$(echo ${sandbox_name} | awk -F"-" '{print $3}')

path_to_repo="/ftppool/private/${repo_name}/last"

cd ${HOME}/hsh-sandboxes
mkdir ${sandbox_name}

cd ${sandbox_name}
mkdir hasher tmp
touch apt.conf priorities sources.list

cat > priorities <<EOF
Important:
    basesystem
    altlinux-release-${repo_name}
Required:
    apt
EOF

cat > apt.conf <<EOF
Dir::Etc::main /dev/null;
Dir::Etc::parts /var/empty;
Dir::Etc::sourcelist ${HOME}/hsh-sandboxes/${sandbox_name}/sources.list;
Dir::Etc::pkgpriorities ${HOME}/hsh-sandboxes/${sandbox_name}/priorities;
Dir::Etc::sourceparts /var/empty;
EOF

if [ ${repo_arch} == "x86_64" ]; then
cat > sources.list <<EOF
rpm file:${path_to_repo} x86_64 classic
rpm file:${path_to_repo} x86_64-i586 classic
rpm file:${path_to_repo} noarch classic
EOF
else
cat > sources.list <<EOF
rpm file:${path_to_repo} i586 classic
rpm file:${path_to_repo} noarch classic
EOF
fi
