#!/bin/bash

# bnp: fetch bnp's different sources
echo "Fetching via scrapper:"
cd scrapper
./bnp.sh
cd ..
echo "Fetching via dublin core:"
cd dublin-core
./bnp.sh
cd ..
