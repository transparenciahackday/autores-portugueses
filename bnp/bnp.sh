#!/bin/bash

session=$(wget http://catalogo.bnportugal.pt -o /dev/null -O -|grep location|grep session|grep http|cut -d= -f3|cut -d\& -f1)

for x in {a..z}; do for y in {a..z}; do echo "Processing: $x$y"; wget "http://catalogo.bnportugal.pt/ipac20/ipac.jsp?session=$session&menu=search&aspect=advanced&npp=10000&ipp=10000&spp=10000&profile=bn&ri=&index=AUTHOR&term=$x$y&x=0&y=0&aspect=advanced" -o /dev/null -O $x$y; done; done
