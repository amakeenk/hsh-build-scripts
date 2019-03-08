#!/bin/sh -e

working_dir="/home/amakeenk/alt/pkgs"

reponame="$1"
upstream_repo_url="$2"

[ -z "${reponame}" -o -z "${upstream_repo_url}" ] && echo "Usage: $0 reponame upstream_repo_url" && exit 1


ssh git.alt init-db ${reponame}

git clone git.alt:packages/${reponame}.git

cd ${working_dir}/${reponame}

mkdir .gear

git remote add upstream ${upstream_repo_url}

gear-remotes-save
git commit -m "gear-remotes-save"
git push

git fetch upstream master:upstream

cat > .gear/rules <<EOF
tar: @version@:.
spec: .gear/${reponame}.spec
EOF

cat > .gear/${reponame}.spec <<EOF
%define _unpackaged_files_terminate_build 1

Name: 
Version: 
Release: alt1

Summary: 
License: 
Group: 

URL: 
Source: %name-%version.tar

BuildRequires(pre): 

BuildRequires: 

%description

%prep
%setup

%build
%install
%files
EOF