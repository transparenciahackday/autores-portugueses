#!/bin/bash

# Lista todas as obras catalogadas de determinado autor

# Verifica se a base de dados existe, se não existir então descarrega-a
if [ ! -f a0511.ttl ]; then
  echo "Database isn't available, let's fetch it!"
  bash bnp.sh
fi

autor="$*"

echo "<b>$autor</b>"
for r in $(
  grep "rdaa:P50111 \"$autor\"" a0511.ttl -B3|grep theeuropeanlibrary|cut -d\< -f2|cut -d\> -f1
); do
  obra=$(grep "$r> a <" a0511.ttl -A6|grep rdam:P30156|cut -d\" -f2);
  echo "<li>$obra</li>";
done
echo "</p>"
