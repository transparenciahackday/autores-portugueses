#!/bin/bash

# Este script analiza os dados presentes no catálogo, retirando
# dele a lista de autores, para o ficheiro lista-de-autores.txt .
#
# Cria também o ficheiro autores-com-datas.txt , que só lista os autores com
# informação de data de nascimento ou morte.
#
# Finalmente, gera um autores-possivelmente-mortos.txt , auto-explicativo, e um
# autores-quase-garantidamente-falecidos.csv , ainda mais filtrado.

echo "A extrair uma lista de autores"
rm lista-de-autores
grep "<dc:creator>" a0511.dc.xml | sort -u > lista-de-autores

# Vamos eliminar da lista um conjunto de palavras-chave que, sendo pertencente
# a "nomes de autores", se referem a autores colectivos (ex.: "Escola
# Sabatina") e não a pessoas singulares
echo "A limpar a lista de autores"
cat lista-de-autores| \
  grep -v "Escola "|grep -v "Escolas "|grep -v "Escolares "|grep -v "Publishing"| \
  grep -v "AA"|grep -v "A\.A"|grep -v -i "animation"|grep -v "ABA"|grep -v "Ábaco"| \
  grep -v "Abadia de"|grep -v "Abadia São"|grep -v "Restaurante" \
  > lista-de-autores.txt

echo "A criar uma lista de autores informação de datas associada"
cat lista-de-autores.txt |grep [1-9] > autores-com-datas.txt

echo "A criar uma lista de autores potencialmente mortos"
rm autores-quase-garantidamente-falecidos
grep "fl\." autores-com-datas.txt > autores-quase-garantidamente-falecidos
grep ".*[0-9][0-9][0-9][0-9].*[0-9]" autores-com-datas.txt|grep -v "fl\." >> \
  autores-quase-garantidamente-falecidos
echo "A formatar o ficheiro resultante"
cat autores-quase-garantidamente-falecidos |cut -d\> -f2-|sed 's/<\/dc:creator>//g' > autores-quase-garantidamente-falecidos.txt
