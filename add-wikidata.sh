#!/bin/bash

## For now, wikidata source isn't consolidated in any way. This script hacks
## around it. It assumes a morreu-em-1951.csv exists locally (with the dead
## authors from other sources) and an wikidata/autores.csv also exists (due a
## previous run of wikidata scripts).

# TODO: read filename insead of using an hardcoded one

cp morreu-em-1951.csv sem-wikidata.csv

while read -r author
do
	if [ "$(grep -i "$author" sem-wikidata.csv |wc -l)" -ne "0" ]; then
		grep -i -v "$author" sem-wikidata.csv > tmp; mv tmp sem-wikidata.csv
	fi;
	grep "$author" wikidata/autores.csv;
done < <(cat wikidata/autores.csv|cut -d\" -f2) > com-wikidata.csv
cat sem-wikidata.csv >> com-wikidata.csv

echo "com-wikidata.csv generated"
