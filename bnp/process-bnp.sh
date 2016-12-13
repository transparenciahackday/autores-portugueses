#!/bin/bash

# bnp: process bnp's different sources, then consolidates result here.
echo "Processing scrapper data:"
cd scrapper
./process-bnp.sh
cd ..
echo "Processing dublin core data:"
cd dublin-core
./process-bnp.sh
cd ..
echo "Consolidating results:"
echo ":: lista-de-autores.txt"
cp scrapper/lista-de-autores.txt lista-de-autores
cat dublin-core/lista-de-autores.txt |cut -d\> -f2-|sed 's/<\/dc:creator>//g' >> lista-de-autores
sort -u lista-de-autores > lista-de-autores.txt
echo "::autores-quase-garantidamente-falecidos.txt"
cat scrapper/autores-quase-garantidamente-falecidos.csv \
  dublin-core/autores-quase-garantidamente-falecidos.txt |sort -u > \
  autores-quase-garantidamente-falecidos.txt
