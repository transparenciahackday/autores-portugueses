#!/bin/bash

# This script uses a CSV list of authors, all of which have died on the same
# year, and generates a wikipage for that list.
# The CSV is expected to be in the following format:
# "Author Name"; "year of birth"; "year of death"

csvfile=$1;
wikifile=$(echo "$csvfile"|cut -d. -f1);
year=$(($(head "$csvfile" -n1|cut -d\; -f3|cut -d\" -f2) + 71));

{
	# Texto introdutório
	echo "Quando o [[direito autoral]] de uma obra expira, ela entra em '''[[domínio público]]'''.";
	echo "Em Portugal, uma obra entra em [[domínio público]] 70 anos após a morte do autor.<ref>{{citar web|url=http://www.pgdlisboa.pt/leis/lei_mostra_articulado.php?artigo_id=484A0031&nid=484&tabela=leis&pagina=1&ficha=1&so_miolo=&nversao=#artigo |título=CÓDIGO DO DIREITO DE AUTOR E DOS DIREITOS CONEXOS| acessodata=2018-12-29}}</ref>";
	echo "Segue-se uma '''lista de autores Portugueses cujas obras entram em domínio público em $year'''.";

	# cabeçalho da tabela
	echo "{| class=\"wikitable sortable\" border=\"1\" style=\"border-spacing:0; style=\"width:100%;\"";
	echo "! Nome";
	echo "! Data de Nascimento";
	echo "! Data de Morte";
	echo "|-";
	
	# dados para a tabela, vindos do CSV
	while read -r entry
	do
		author=$(echo "$entry"|cut -d\; -f1|cut -d\" -f2);
		birth=$(echo "$entry"|cut -d\; -f2|cut -d\" -f2);
		death=$(echo "$entry"|cut -d\; -f3|cut -d\" -f2);
		echo "| [[$author]]";
		echo "| $birth";
		echo "| $death";
		echo "|-";
	done < "$csvfile"

	# footer
	echo "|}"
	echo ""
	echo "==Referências=="
	echo "{{reflist}}"
	echo ""
	echo "[[Categoria:Domínio público]]"
	echo "[[Categoria:$year]]"
} > "$wikifile"
