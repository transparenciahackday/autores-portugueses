#!/bin/bash
#
# consolida.sh: gera uma lista consolidada de autores a partir dos dados
#               (previamente processados) das várias fontes existentes.

echo "A pré-processar a fonte: dglb"
rm dglb.csv 2> /dev/null

# Nota: isto tem mais complexidade do que precisaria, porque queremos que o CSV
# gerado seja exactamente no mesmo formato e com as mesmas nuances que o da
# fonte bnp, para termos mais sorte no teste de uniqueness.
tail -n +2 "dglb/autores.csv" | while read -r entry; do
	autor=$(echo "$entry"|cut -d\; -f2)
	if [ "$autor" != "" ]; then
		echo -n "\"$autor\";" >> dglb.csv
		nascimento=$(echo "$entry"|cut -d\; -f3)
		if [ "$nascimento" != "" ]; then
			echo -n " \"$nascimento\"; " >> dglb.csv
		else
			echo -n ";" >> dglb.csv
		fi
		morte=$(echo "$entry"|cut -d\; -f5)
		if [ "$morte" != "" ]; then
			echo -n "\"$morte\"" >> dglb.csv
		else
			if [ "$nascimento" != "" ]; then
				echo -n "\"\"" >> dglb.csv
			fi
		fi
		echo "" >> dglb.csv
	fi
done

echo "A gerar a lista final"
echo "\"Autor\";\"Data de Nascimento\";\"Data de Morte\"" > lista-final.csv
echo "$(tail -n +2 "bnp/authors.csv"; cat dglb.csv)"|sort -u >> lista-final.csv
