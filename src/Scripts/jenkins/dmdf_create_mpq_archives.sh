#!/bin/bash

# Build smpq
wget https://launchpad.net/smpq/trunk/1.6/+download/smpq_1.6.orig.tar.gz
tar -xjf smpq_1.6.orig.tar.gz
cd ./smpq-1.6
mkdir ./build
cd ./build
cmake ..
make

# TODO create the two MPQ archives War3Mod.mpq into <project folder>/mpq/en and <project folder>/mpq/de.
