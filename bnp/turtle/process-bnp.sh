#!/bin/bash

# Notes on how to parse this:
# rdaa:P50111 is "Author's name"
# rdaa:P50120 is "date of death"
# rdaa:P50098 is "dates of birth and death"

echo "Processing the database"
grep rdaa:P50111 -A2 a0511.ttl|grep rdaa|grep -v _:node|tr '\n' ';'| \
  sed 's/rdaa:P50111/\n/g'|sed 's/;$//g'|sed 's/;;/;/g' |sort -u > authors-and-dates.csv

# we have these kinds of lines:
# 1) "Author";
# 2) "Author"; rdaa:P50098 "dates of birth and death";
# 3) "Author"; rdaa:P50111 "birth date";
# 4) "Author"; rdaa:P50111 "birth date"; rdaa:P50120 "death date";

echo "Generating the CSV"
echo "\"Author\"; \"Birth Date\"; \"Death Date\"" > sanitized.csv

# 1) "Author";
echo ": Processing authors without date information"
grep -v rdaa authors-and-dates.csv|cut -d\" -f2 | while read -r entry; do
  echo "\"$entry\";;" >> sanitized.csv
done

# 2) "Author"; rdaa:P50098 "dates of birth and death";
echo ": Processing authors with date information in \"birth-death\" format"
grep rdaa:P50098 authors-and-dates.csv | while read -r entry; do
  author=$(echo "$entry"|cut -d\" -f2);
  dates=$(echo "$entry"|cut -d\" -f4|sed 's/\ -\ /D/g');
  birth=$(echo "$dates"|cut -dD -f1);
  death=$(echo "$dates"|cut -dD -f2);
  echo "\"$author\"; \"$birth\"; \"$death\"" >> sanitized.csv
done
