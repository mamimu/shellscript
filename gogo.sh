#!/bin/sh

find $1 -name "*.wav" > file

while read line ;
do
gogo "$line" "$line".mp3
rm $line
done < file

rm file
