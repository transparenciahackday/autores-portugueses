#!/bin/bash

## For now, wikidata source isn't consolidated in any way. This script hacks
## around it. It assumes a .csv exists locally (with the dead authors from
## other sources), its filename passed as an argument, and an
## wikidata/autores.csv also exists (due a previous run of wikidata scripts).

# Validate if we have the correct number of arguments
if [ $# -ne 1 ]; then
	echo "Usage: $0 <who-died-that-year.csv>"
	echo "Note: who-died-that-year.csv is expected to be the result of a quem-morreu.sh run."
	exit 1
fi

cp "$1" sem-wikidata.csv

while read -r author
do
	if [ "$(grep -i "$author" sem-wikidata.csv |wc -l)" -ne "0" ]; then
		grep -i -v "$author" sem-wikidata.csv > tmp; mv tmp sem-wikidata.csv
	fi;
	grep "$author" wikidata/autores.csv;
done < <(cat wikidata/autores.csv|cut -d\" -f2) > com-wikidata.csv
cat sem-wikidata.csv >> com-wikidata.csv

echo "com-wikidata.csv generated"
