#!/bin/bash

# bnp: second version of a bnp script to process the bnp catalog in order to
# fetch a list of Portuguese Authors

echo "fetching data (dublin core format)"
wget http://data.theeuropeanlibrary.org/download/opendata/a0511.dc.xml.gz

# unpack data
echo "unpacking data"
gunzip a0511.dc.xml.gz
