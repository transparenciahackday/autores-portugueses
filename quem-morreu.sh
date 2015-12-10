# script that lists all authors that died in a certain year
# (looks at both lists)

# TODO - get this as an argument
YEAR=1945

echo "$(cat dglb/autores.csv |cut -d\; -f2-5|grep $YEAR$ ; grep $YEAR bnp/autores-quase-garantidamente-falecidos.csv|grep -v $YEAR-)" |sort -u
