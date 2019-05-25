#!/bin/sh -e

sandbox_name=$1

[ -z ${sandbox_name} ] && echo -e "\e[1;31mUsage\e[0m: $0 repo_name-package_name-repo_arch
repo_name: sisyphus,p8,c7,c7.1,c8,c8.1
repo_arch: x86_64,i586" && exit 1

repo_name=$(echo ${sandbox_name} | awk -F"-" '{print $1}')
repo_arch=$(echo ${sandbox_name} | awk -F"-" '{print $3}')

path_to_repo="/ftppool/private/${repo_name}/last"

sandbox_path="${HOME}/hsh-sandboxes/${sandbox_name}"

mkdir -p ${HOME}/hasher
mkdir -p ${sandbox_path}/{hasher,tmp}

cat > ${sandbox_path}/priorities <<EOF
Important:
    basesystem
    altlinux-release-${repo_name}
Required:
    apt
EOF

cat > ${sandbox_path}/apt.conf <<EOF
Dir::Etc::main /dev/null;
Dir::Etc::parts /var/empty;
Dir::Etc::sourcelist ${HOME}/hsh-sandboxes/${sandbox_name}/sources.list;
Dir::Etc::pkgpriorities ${HOME}/hsh-sandboxes/${sandbox_name}/priorities;
Dir::Etc::sourceparts /var/empty;
EOF

if [ ${repo_arch} == "x86_64" ]; then
cat > ${sandbox_path}/sources.list <<EOF
rpm file:${path_to_repo} x86_64 classic
rpm file:${path_to_repo} x86_64-i586 classic
rpm file:${path_to_repo} noarch classic
EOF
else
cat > ${sandbox_path}/sources.list <<EOF
rpm file:${path_to_repo} i586 classic
rpm file:${path_to_repo} noarch classic
EOF
fi
