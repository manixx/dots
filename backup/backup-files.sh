#!/bin/zsh 
#
# Backup sensitive data and encrypt it with my GPG key. 
#
# Usage: backup-files <gpg-id> <path-where-to-save-gpg-file> 
#

set -ex

exec_dir=$(dirname $0)
return_dir=$(pwd)

cd ${exec_dir}

if [ -z $1 ]; then 
  echo "Please specify GPG key (recipient)"
  exit 1
fi 

if [ -z $2 ]; then 
  echo "Please specify path as second argument"
  exit 1
fi 

if [ -d .temp ]; then 
  rm -rf .temp 
fi 

if [ -d .temp.tar.gz ]; then 
  rm .temp.tar.gz 
fi 

mkdir -p .temp 

#
# ssh files 
#

mkdir -p .temp/ssh 
cp ~/.ssh/id_rsa* .temp/ssh

#
# password-store
#

mkdir -p .temp/password-store
cp ~/.password-store/* .temp/password-store -r 

#
# netctl profiles 
#

netctl_profiles=$(find /etc/netctl -maxdepth 1 -type f)
if [ -n ${netctl_profiles} ]; then 
  echo "netctl profiles found: \n${netctl_profiles}"
  mkdir -p .temp/netctl-profiles 
  cp "${netctl_profiles}" .temp/netctl-profiles
fi 

# 
# background images 
#

if [ -d ~/.bg ]; then 
  mkdir -p .temp/bg 
  cp ~/.bg/* .temp/bg 
fi 

# 
# taskwarrior 
#

if [ -d ~/.task ]; then
  mkdir -p .temp/task
  cp ~/.task/* .temp/task -r 
fi

tar cfz .temp.tar.gz -C .temp . 
gpg --recipient $1 --encrypt --out $(pwd)/${2} .temp.tar.gz

rm .temp.tar.gz
rm -rf .temp

cd ${return_dir}
