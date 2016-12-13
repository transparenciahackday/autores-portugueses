#!/bin/bash

# script that lists all authors that died in a certain year
# (looks at both lists)

# Validate if we have the correct number of arguments
if [ $# -ne 1 ]; then
	echo "Usage: $0 <year>"
	exit 1
fi

# Check if <year> is a valid argument
if ! [[ "$1" =~ ^[0-9][0-9][0-9][0-9]$ ]]; then
	echo "The <year> argument must be a four digits number (eg: 1950)."
	exit 2
fi

echo "$(
	cat dglb/autores.csv | \
	cut -d\; -f2-5| \
	grep $1$ ; grep $1 bnp/autores-quase-garantidamente-falecidos.txt| \
	grep -v $1- | \
	grep -v "$1 -"
)" |sort -u
