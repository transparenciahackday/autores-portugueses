#!/bin/bash

# Este script analiza os dados presentes nos ficheiros 'aa' a 'zz' retirando
# deles a lista de autores, para o ficheiro lista-de-autores.txt .
#
# Cria também o ficheiro autores-com-datas.txt , que só lista os autores com
# informação de data de nascimento ou morte.
#
# Finalmente, gera um autores-possivelmente-mortos.txt , auto-explicativo, e um
# autores-quase-garantidamente-falecidos.csv , ainda mais filtrado.

rm lista-de-autores; touch lista-de-autores

for x in {a..z}; do
  for y in {a..z}; do
    grep "Ver mais info" $x$y|grep AUTHOR|grep -v "Ver: "|cut -d\" -f7|cut -d\< -f1|sed 's/^>/<br\/>/'|html2text >> lista-de-autores ;
  done;
done;

sort -u lista-de-autores > lista-de-autores.txt
grep , lista-de-autores.txt |grep [1-9] | sed 's/\(.*\),/\1;/' > autores-com-datas.txt

l=$(cat autores-com-datas.txt |wc -l); 
rm autores-possivelmente-mortos.txt; touch autores-possivelmente-mortos.txt
for i in $(seq 1 $l); do
  if [ $(head -n $i autores-com-datas.txt|tail -n 1|cut -d\; -f2|grep [1-9]|grep "-"|wc -l) -eq $(echo "1") ]; 
    then head -n $i autores-com-datas.txt|tail -n 1 >> autores-possivelmente-mortos.txt; 
  fi;
  if [ $(head -n $i autores-com-datas.txt|tail -n 1|cut -d\; -f2|grep [1-9]|grep "-"|wc -l) -eq $(echo "0") ]; 
    then head -n $i autores-com-datas.txt|tail -n 1|grep "fl\." >> autores-possivelmente-mortos.txt;
  fi;
done

grep "fl\." autores-possivelmente-mortos.txt > autores-quase-garantidamente-falecidos.csv
l=$(grep -v "fl\." autores-possivelmente-mortos.txt|wc -l);
for i in $(seq 1 $l); do
  if [ $(grep -v "fl\." autores-possivelmente-mortos.txt|head -n $i|tail -n 1|cut -d\; -f2|grep [1-9]|wc -l) -eq $(echo "1") ];
    then grep -v "fl\." autores-possivelmente-mortos.txt|head -n $i|tail -n 1 >> autores-quase-garantidamente-falecidos.csv;
  fi;
done
