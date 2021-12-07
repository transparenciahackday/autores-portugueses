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

# Portuguese people whose works enter the public domain in $year
query='
SELECT DISTINCT ?item (year(?birthdate) as ?birthyear) WHERE {
  ?item wdt:P31 wd:Q5.
  ?item wdt:P27 wd:Q45.
  ?item wdt:P570 ?time0. hint:Prior hint:rangeSafe true.
  OPTIONAL{?item wdt:P569 ?birthdate .}
  FILTER((?time0 >= "'$year'-01-01"^^xsd:dateTime) && (?time0 < "'$((year+1))'-01-01"^^xsd:dateTime))
}
'

echo "$query" | ./query-wikidata.sh > autores.xml || (echo "Error trying to query wikidata!" && exit 1);
test $? -ne 0 && exit 1;

# We didn't query with the label service to be lighter on our queries... so now
# we'll need to ask for the names of each author item.
# Also, we didn't really filter them out by authors! Doing it now, too...
echo -n "" > autores-e-nomes.xml
while read -r line
do
  item=$(echo "$line"|cut -d\; -f1);
  yob=$(echo "$line"|cut -d\; -f2);
  query='
    SELECT ?label
    WHERE {
    wd:'$item' rdfs:label ?label .
    wd:'$item' (wdt:P106/wdt:P279*) wd:Q2500638.
    FILTER (langMatches(lang(?label), "pt"))
    } LIMIT 1
  ';
  echo "$line" >> autores-e-nomes.xml;
  echo "$query" | ./query-wikidata.sh >> autores-e-nomes.xml || (echo "Error trying to query wikidata!" && exit 1);
  test $? -ne 0 && exit 1;
done < <(grep entity autores.xml -A3|sed 's/\t//g'|tr --delete '\n'|sed 's/--/\n/g'|sed "s/<uri>http:\/\/www.wikidata.org\/entity\///g"|sed "s/<\/uri><\/binding><binding name='birthyear'><literal datatype='http:\/\/www.w3.org\/2001\/XMLSchema#integer'>/;/g"|cut -d\< -f1)
echo "autores-e-nomes.xml gerado"

# Let's turn this into a csv (wikidata;yob;name)
grep literal -B9 autores-e-nomes.xml|sed 's/\t//g'|tr --delete '\n'|sed 's/--/\n/g'| \
  sed "s/<?xml version='1.0' encoding='UTF-8'?><sparql xmlns='http:\/\/www.w3.org\/2005\/sparql-results#'><head><variable name='label'\/><\/head><results><result><binding name='label'><literal xml:lang='pt'>/;/g"| \
  sed "s/<\/literal>//g" > autores-temp.csv
echo "" >> autores-temp.csv

# Actually, if the item didn't have an date of birth, we have an entry in the
# format "wikidata;name" where it should be "wikidata;;name"... Let's fix that:
while read -r line; do
  fields="${line//[^;]}";
  if [ "${#fields}" -eq 2 ]; then
    echo "$line";
  else
    echo "$(echo "$line"|cut -d\; -f1);;$(echo "$line"|cut -d\; -f2)";
  fi
done < autores-temp.csv > autores-temp-fixed.csv
mv autores-temp-fixed.csv autores-temp.csv

# Let's turn this into the expected csv
# "Author Name";"Year of Birth";"Year of Death";"Wikidata Item"
while read -r line; do wd=$(echo $line|cut -d\; -f1); yob=$(echo $line|cut -d\; -f2); name=$(echo $line|cut -d\; -f3); echo "\"$name\";\"$yob\";\"$year\";\"$wd\""; done < autores-temp.csv > autores.csv
echo "autores.csv gerado"
