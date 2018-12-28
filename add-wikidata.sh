#!/bin/bash

## For now, wikidata source isn't consolidated in any way. This script hacks
## around it. It assumes a morreu-em-1948.csv exists locally (with the dead
## authors from other sources) and an wikidata/autores.csv also exists (due a
## previous run of wikidata scripts).

while read -r author
do
	if [ "$(grep -i "$author" morreu-em-1948.csv |wc -l)" -eq "0" ]; then
		grep "$author" wikidata/autores.csv;
	fi;
done < <(cat wikidata/autores.csv|cut -d\" -f2) > com-wikidata.csv
cat morreu-em-1948.csv >> com-wikidata.csv

echo "com-wikidata.csv generated"
