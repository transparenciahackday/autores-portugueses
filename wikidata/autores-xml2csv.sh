#!/bin/bash

#echo "\"Autor\";\"Data de Nascimento\";\"Data de Morte\""

# authors=$(grep literal autores.xml |cut -d\> -f2|cut -d \< -f1)

while read -r line
do
  echo "\"$line\";\"\";\"1948\"";
done < <(grep literal autores.xml |cut -d\> -f2|cut -d \< -f1)
