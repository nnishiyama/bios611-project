#!/bin/bash

# $1 is the directory path

for f in ${1}*.txt.gz; do gunzip ${f};done;
