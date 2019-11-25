#!/bin/sh 

for package in packages/*; do 
  ${package}/setup.sh 
done
