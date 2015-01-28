#!/bin/bash

subject=$1
email=$2
body=$3
file=$4


echo "$body" > info.txt
echo " " >> info.txt
echo " " >> info.txt
echo " " >> info.txt
echo "Linux-backup-lts Infos:" >> info.txt
echo "--------------------------------------------------------------------" >> info.txt
echo " " >> info.txt
df -kh >> info.txt
echo " " >> info.txt
echo "--------------------------------------------------------------------" >> info.txt
echo " " >> info.txt
free -m >> info.txt
echo " " >> info.txt
echo "--------------------------------------------------------------------" >> info.txt
echo " " >> info.txt
w >> info.txt
echo " " >> info.txt
echo "--------------------------------------------------------------------" >> info.txt
echo " " >> info.txt
who >> info.txt

if [ -z "$file" ]; then
        cat info.txt | mail -s "$subject" "$email"
else
        cat info.txt | mail -s "$subject" -a "$file" "$email"
fi

rm -f info.txt
