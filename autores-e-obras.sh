#!/bin/bash

# Recebe como argumento um ficheiro com os resultados do quem-morreu.sh , e
# gera HTML com uma lista destes autores e as suas obras.

# TODO: ler ficheiro como argumento
lista="1946-lista-final-3.csv"

# por agora, ainda só temos como fazer isto para a bnp...
cd bnp || { echo "não há uma directoria bnp!"; exit; }
cut -d\" -f2 < ../$lista|sort -u|while read -r autor; do
	./obras-de-autor.sh "$autor"
done
cd ..
