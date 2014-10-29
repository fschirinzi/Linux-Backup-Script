#!/bin/bash

subject=$1
email=$2
body=$3
file=$4


sudo echo "$body" > info.txt
sudo echo " " >> info.txt
sudo echo " " >> info.txt
sudo echo " " >> info.txt
sudo echo "Linux-backup-lts Infos:" >> info.txt
sudo echo "--------------------------------------------------------------------" >> info.txt
sudo echo " " >> info.txt
sudo df -kh >> info.txt
sudo echo " " >> info.txt
sudo echo "--------------------------------------------------------------------" >> info.txt
sudo echo " " >> info.txt
sudo free -m >> info.txt
sudo echo " " >> info.txt
sudo echo "--------------------------------------------------------------------" >> info.txt
sudo echo " " >> info.txt
sudo w >> info.txt
sudo echo " " >> info.txt
sudo echo "--------------------------------------------------------------------" >> info.txt
sudo echo " " >> info.txt
sudo who >> info.txt

if [ -z "$file" ]; then
        cat info.txt | mail -s "$subject" "$email"
else
        cat info.txt | mail -s "$subject" -a "$file" "$email"
fi

sudo rm info.txt
