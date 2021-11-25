#!/bin/bash
year=0;
if [ "$1" != "" ]; then
	year=$(($1-71));
else
    echo "Please enter an year as an argument.";
	echo "The year you enter should represent the year for which you want a list of authors entering public domain.";
	echo "For instance, is you give '2019' as an argument, this will give you a list of Portuguese authors whose works enter the public domain in 2019 (died in 1948).";
	exit;
fi

# Portuguese authors whose works enter the public domain in $year
query='
SELECT DISTINCT ?item WHERE {
  ?item wdt:P31 wd:Q5.
  ?item wdt:P27 wd:Q45.
  ?item wdt:P570 ?time0. hint:Prior hint:rangeSafe true.
  FILTER((?time0 >= "'$year'-01-01"^^xsd:dateTime) && (?time0 < "'$((year+1))'-01-01"^^xsd:dateTime))
  ?item (wdt:P106/wdt:P279*) wd:Q482980.
}
'

echo "$query" | ./query-wikidata.sh > autores.xml || (echo "Error trying to query wikidata!" && exit 0)
echo "autores.xml gerado"

# We didn't query with the label service to be lighter on our queries... so now
# we'll need to ask for the names of each author item:
echo -n "" > autores-e-nomes.xml
while read -r line
do
  query='
    SELECT ?label
    WHERE {
    wd:'$line' rdfs:label ?label .
    FILTER (langMatches(lang(?label), "pt"))
    }
  ';
  echo "$query" | ./query-wikidata.sh >> autores-e-nomes.xml || (echo "Error trying to query wikidata!" && exit 0);
done < <(grep entity autores.xml |cut -d/ -f5|cut -d \< -f1)
echo "autores-e-nomes.xml gerado"

# Let's turn this into the expected csv
while read -r line
do
  echo "\"$line\";\"\";\"$year\"";
done < <(grep lang=\'pt\' autores-e-nomes.xml |cut -d\> -f2|cut -d \< -f1) > autores.csv
echo "autores.csv gerado"
