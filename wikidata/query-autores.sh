#!/bin/bash

# The query we want to make

year=0;
if [ "$1" != "" ]; then
	year=$(($1-71));
else
    echo "Please enter an year as an argument.";
	echo "The year you enter should represent the year for which you want a list of authors entering public domain.";
	echo "For instance, is you give '2019' as an argument, this will give you a list of Portuguese authors whose works enter the public domain in 2019 (died in 1948).";
	exit;
fi

#Portuguese authors whose works enter the public domain in 2019 (died in 1948)
query='
SELECT DISTINCT ?item ?itemLabel WHERE {
  ?item wdt:P31 wd:Q5.
  ?item (wdt:P106/wdt:P279*) wd:Q482980.
  ?item wdt:P570 ?time0.
  FILTER((?time0 >= "'$year'-01-01"^^xsd:dateTime) && (?time0 < "'$((year+1))'-01-01"^^xsd:dateTime))
  ?item wdt:P27 wd:Q45.
  SERVICE wikibase:label { bd:serviceParam wikibase:language "pt". }
}
'

echo "$query" | ./query-wikidata.sh > autores.xml || echo "Error trying to query wikidata!" && exit 0
echo "autores.xml gerado"

while read -r line
do
  echo "\"$line\";\"\";\"$year\"";
done < <(grep literal autores.xml |cut -d\> -f2|cut -d \< -f1) > autores.csv
echo "autores.csv gerado"
