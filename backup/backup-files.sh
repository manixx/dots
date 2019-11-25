#!/bin/zsh 

set -ex

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

mkdir -p .temp/netctl-profiles 
cp $(find /etc/netctl -maxdepth 1 -type f) .temp/netctl-profiles

mkdir -p .temp/ssh 
cp ~/.ssh/id_rsa* .temp/ssh

mkdir -p .temp/bg 
cp ~/.bg/* .temp/bg 

mkdir -p .temp/password-store
cp ~/.password-store/* .temp/password-store -r 

tar cfz .temp.tar.gz -C .temp . 
gpg --recipient $1 --encrypt --out ${2} .temp.tar.gz

rm .temp.tar.gz
rm -rf .temp
