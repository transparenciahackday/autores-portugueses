Autores Portugueses
===================

Este conjunto de scripts e listas foram inicialmente feitos para gerar, como
resultado, este artigo:
* http://ensinolivre.pt/?p=285

## Direção Geral do Livro

A Direção Geral do Livro, agora Direcção Geral do Livro, dos Arquivos e das
Bibliotecas, mantinha uma base de dados de autores.
Infelizmente já não o faz, mas, na directoria `dglb`, ainda se encontram dados
provenientes de lá, e, a partir deles, foi gerado o CSV
`autores-e-suas-mortes.csv`. O script `autores.py`, também naquela directoria,
faz uma melhor análise dos dados desta fonte, gerando o ficheiro `autores.csv`.

## Biblioteca Nacional

Existe também outro conjunto de scripts, que gera uma outra lista de autores,
mas com dados vindos de outra fonte, na directoria `bnp`. Mais tarde, estas
duas listas devem ser fundidas numa só. O script `bnp.sh` descarrega os dados
em bruto, que são depois processados pelo script `process-bnp.sh`. A lista
resultante de autores é a `authors.csv`.

## Wikidata

Ainda não preparado, mas seria útil começar a usar também o Wikidata como fonte
(e, porque não, alimentá-la com as outras).

## Dados consolidados

O script `consolida.sh` processa as listas de cada uma das fontes (previamente
geradas), e consolida-as numa só lista, `lista-final.csv`.

## Outras ferramentas

* `quem-morreu.sh` -- gera um csv com a lista de todos os autores que morreram
  em determinado ano.
* `autores-e-obras.sh` -- gera uma lista de obras, ordenadas por autor, a
  partir de uma lista de autores no formato do output do `quem-morreu.sh`. A
  lista é gerada em HTML.
