#!/bin/bash

# bnp.sh -- fetch BNP data, on Turtle format
echo "Fetching:"
wget http://data.theeuropeanlibrary.org/download/opendata/a0511.ttl.gz
echo "Uncompressing:"
gunzip a0511.ttl.gz
