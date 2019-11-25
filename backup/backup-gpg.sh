#!/bin/sh 

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

gpg --output .temp/backup.pgp --armor --export --export-options export-backup $1
gpg --output .temp/priv.gpg --armor --export-secret-keys $1 
gpg --export-ownertrust > .temp/ownertrust.txt 

tar cfz .temp.tar.gz -C .temp .

echo "Please give passphrase for GPG keys..."
gpg --output ${2} --symmetric .temp.tar.gz 

rm -rf .temp 
rm -rf .temp.tar.gz 

