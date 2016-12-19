#!/bin/bash

# Lista todas as obras catalogadas de determinado autor

autor="$*"

echo "<b>$autor</b>"
for r in $(
  grep "rdaa:P50111 \"$autor\"" a0511.ttl -B3|grep theeuropeanlibrary|cut -d\< -f2|cut -d\> -f1
); do
  obra=$(grep "$r> a <" a0511.ttl -A6|grep rdam:P30156|cut -d\" -f2);
  echo "<li>$obra</li>";
done
echo "</p>"
