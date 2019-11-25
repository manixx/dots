#!/bin/sh 

set -ex 

if [ -z $1 ]; then 
  echo "Please specify GPG key (recipient)"
  exit 1
fi 


if [ -f backup-files.gpg ]; then 
  rm backup-files.gpg 
fi 

if [ -f backup-gpg.gpg ]; then 
  rm backup-gpg.gpg 
fi 

echo "Backing up sensitive data..." 

read -p "Proceed?" -n 1 -r
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
  exit 0
fi

./backup-files.sh $1 backup-files.gpg
./backup-gpg.sh   $1 backup-gpg.gpg

tar cfz backup-$(date +%N).tar.gz backup-files.gpg backup-gpg.gpg  

rm backup-files.gpg backup-gpg.gpg 
