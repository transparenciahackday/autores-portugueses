# get the source files
echo "Going to fetch source files from 1000 to 20000:";
for i in $(seq 1000 9999);     do echo $i; wget "http://www.dglb.pt/sites/DGLB/Portugues/autores/Paginas/PesquisaAutores1.aspx?AutorId=$i" -O $i.html -o /dev/null; done # start...
for i in $(seq 10000 20000);   do echo $i; wget "http://www.dglb.pt/sites/DGLB/Portugues/autores/Paginas/PesquisaAutores1.aspx?AutorId=$i" -O $i.html -o /dev/null; done # enough!

# TODO redo the ones with zero bytes
# for i in $(find . -size 0 -print); do echo "redoing $i"; rm $i; ...

# get the list of actual authors:
for i in $(ls -rt); do echo -n "$i: "; grep "Unhandled Exception:" $i|wc -l; done |grep html|grep 0$ > authors.txt

# generate csv: "death date; author name"
# generate csv: "author name; birth; death"

# TODO FIXME: estamos a assumir que não existem vírgulas nos nomes das cidades, mas às vezes há...
# for i in $(cat authors.txt|cut -d: -f1); do nome=$(grep DetalheNome $i|cut -d\> -f2|cut -d\< -f1); falec=$(grep NascFalec $i|cut -d\[ -f2|cut -d\] -f1|cut -d\, -f2- | { read first rest ; echo $rest ; }|cut -d\, -f2); echo "$falec; $nome"; done > autores-e-suas-mortes.csv
for i in $(cat authors.txt|cut -d: -f1); do nome=$(grep DetalheNome $i|cut -d\> -f2|cut -d\< -f1);tail=$(nascmort=$(grep NascFalec $i|cut -d\[ -f2|cut -d\] -f1); echo $nascmort|sed 's/\ -\ /\;/g'); echo "$nome;$tail"; done > autores-e-suas-mortes.csv

# nascmort=$(grep Falec 10000.html|cut -d\[ -f2|cut -d\] -f1); echo $nascmort|sed 's/\ -\ /\;/g'


# # Só queremos os mortos...
# grep -v ^\; autores-e-suas-mortes.csv > autores-mortos.csv

# # Vamos ver o que é que está "fora do sítio":
# sort -n autores-mortos.csv |grep -v ^\ 2|grep -v ^\ 1|grep -v ^2|grep -v ^1|grep -v ^X|grep -v ^Séc|grep -v ^\ Séc|grep -v ^\ ?|grep -v ^?|cut -d\; -f1|sort -u

