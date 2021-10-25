#!/bin/bash

# $1 is the directory path

for f in ${1}*.txt; 
do BASE=${f##*/}; 
TISSUE=${BASE%%.*}; 
sed -i "" "s/$/	$TISSUE/" $f;
sed -i "" "1s/$TISSUE/tissue/" $f;
done;
