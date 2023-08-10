#!/bin/bash

# FIXME: transformar os nomes de ficheiros hardcoded em argumentos

rm sem-wikidata.csv;
for i in $(seq 1 $(cat quem-morreu-1953.csv |wc -l)); do autor=$(head -n$i quem-morreu-1953.csv|tail -n1|cut -d\; -f1); if [[ $(grep -c "^$autor" wikidata/autores.csv) -eq 0 ]]; then head -n$i quem-morreu-1953.csv|tail -n1 >> sem-wikidata.csv; fi ; done

echo "sem-wikidata.csv criado."
