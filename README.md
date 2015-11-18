Autores Portugueses
===================

Este conjunto de scripts e listas foram inicialmente feitos para gerar, como
resultado, este artigo:
* http://ensinolivre.pt/?p=285

Planeia-se o uso de três fontes de dados distintas, sendo que, por enquanto,
temos duas fontes de informação.

## www.dglb.pt

Na directoria `dglb`, o `script.sh` usa esta fonte, descarregando os dados em
bruto (ver `html-files`), e gerando o CSV `autores-e-suas-mortes.csv` como
resultado.

O script `autores.py` faz uma melhor análise dos dados desta fonte, gerando o
ficheiro `autores.csv`.

## Catálogo BNP

Existe também outro conjunto de scripts, que gera uma outra lista de autores,
mas com dados vindos de outra fonte, na directoria `bnp`. Mais tarde, estas
duas listas devem ser fundidas numa só. O script `bnp.sh` descarrega os dados
em bruto, que são depois processados pelo script `process-bnp.sh`. Para já, os
resultados mais interessantes serão a `lista-de-autores.txt` e o
`autores-quase-garantidamente-falecidos.csv`.

## Melhorias

### Dados consolidados

Além de ter mais uma fonte de dados, queremos também ter os resultados das
várias fontes consolidados num só set de resultados, mas isso ainda não está
desenvolvido.

### Scripts e filtros

Para além de ter uma lista consolidada com toda a informação possível sobre
Autores Portugueses, queremos também desenvolver algumas ferramentas que,
usando esses dados, nos devolvam alguns sub-sets de potencial interesse. Como
poderá ser visível, uma das aplicações que consideramos interessantes é
recolher, a partir de aqui, todos os autores que morreram em determinado ano,
para poder identificar autores (e obras) que entram em domínio público em
determinada data.
