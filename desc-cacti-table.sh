#!/bin/bash

input="/root/table.file"
while IFS= read -r var
do
  echo "\n Desc $var"
  echo "desc $var;"|mysql cacti -uroot -p<PASSWORD> -N
done < "$input"
