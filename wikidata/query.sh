#!/bin/bash

# The query we want to make
# TODO: take the hardcoded dates off the query, get the date from a parameter

#Portuguese authors whose works enter the public domain in 2019 (died in 1948)
query='
SELECT DISTINCT ?item ?itemLabel WHERE {
  ?item wdt:P31 wd:Q5.
  ?item (wdt:P106/wdt:P279*) wd:Q482980.
  ?item wdt:P570 ?time0.
  FILTER((?time0 >= "1948-01-01T00:00:00Z"^^xsd:dateTime) && (?time0 < "1949-01-01T00:00:00Z"^^xsd:dateTime))
  ?item wdt:P27 wd:Q45.
  SERVICE wikibase:label { bd:serviceParam wikibase:language "[AUTO_LANGUAGE],pt". }
}
'

echo "$query" | ./query-wikidata.sh

# # HMTLize the string:
# # replace newlines from the query
# query=${query/%27/$'\n'/}
# echo "$query"
# # replace the # sign
# # replace spaces
# 
# # GET the query:
# echo "Getting the query..."
# echo "https://query.wikidata.org/sparql?query=$html"
# wget "https://query.wikidata.org/sparql?query=$html" -o /dev/null -O result
# echo "...done, check the 'result' file!"
# 

# wget https://query.wikidata.org/sparql?query=SELECT%20DISTINCT%20%3Fitem%20%3FitemLabel%20WHERE%20%7B%0A%20%20%3Fitem%20wdt%3AP31%20wd%3AQ5.%0A%20%20%3Fitem%20%28wdt%3AP106%2Fwdt%3AP279%2a%29%20wd%3AQ482980.%0A%20%20%3Fitem%20wdt%3AP570%20%3Ftime0.%0A%20%20FILTER%28%28%3Ftime0%20%3E%3D%20%221948-01-01T00%3A00%3A00Z%22%5E%5Exsd%3AdateTime%29%20%26%26%20%28%3Ftime0%20%3C%20%221949-01-01T00%3A00%3A00Z%22%5E%5Exsd%3AdateTime%29%29%0A%20%20%3Fitem%20wdt%3AP27%20wd%3AQ45.%0A%7D


# 
# # More info:
# # https://www.wikidata.org/wiki/Wikidata:Introduction/pt
# # https://www.wikidata.org/wiki/Wikidata:Tools/pt
