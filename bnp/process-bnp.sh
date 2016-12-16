#!/bin/bash

# Notes on how to parse this:
# rdaa:P50098 is "dates of birth and death"
# rdaa:P50111 is "Author's name"
# rdaa:P50120 is "date of death"
# rdaa:P50121 is "date of birth"

echo "Processing the database"
grep rdaa:P50111 -A2 a0511.ttl|grep rdaa|grep -v _:node|tr '\n' ';'| \
  sed 's/rdaa:P50111/\n/g'|sed 's/;$//g'|sed 's/;;/;/g' |sort -u > authors-and-dates.csv

# we have these kinds of lines:
# 1) "Author";
# 2) "Author"; rdaa:P50098 "dates of birth and death";
# 3) "Author"; rdaa:P50121 "birth date";
# 4) "Author"; rdaa:P50121 "birth date"; rdaa:P50120 "death date";

echo "Generating the CSV"
rm sanitized.csv 2> /dev/null

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

# 3) "Author"; rdaa:P50121 "birth date";
echo ": Processing authors with birth date information only"
grep rdaa:P50121 authors-and-dates.csv|grep -v rdaa:P50120 | while read -r entry; do
  author=$(echo "$entry"|cut -d\" -f2);
  birth=$(echo "$entry"|cut -d\" -f4);
  echo "\"$author\"; \"$birth\";" >> sanitized.csv
done

# 4) "Author"; rdaa:P50121 "birth date"; rdaa:P50120 "death date";
echo ": Processing authors with birth and death dates"
grep rdaa:P50121 authors-and-dates.csv|grep rdaa:P50120 | while read -r entry; do
  author=$(echo "$entry"|cut -d\" -f2);
  birth=$(echo "$entry"|cut -d\" -f4);
  death=$(echo "$entry"|cut -d\" -f6);
  echo "\"$author\"; \"$birth\"; \"$death\"" >> sanitized.csv
done

echo "Sorting results, into the final authors.csv"
echo "\"Author\"; \"Birth Date\"; \"Death Date\"" > authors.csv
sort -u sanitized.csv >> authors.csv
