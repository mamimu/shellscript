#!/bin/bash
#yahoo! news reader

url=(http://dailynews.yahoo.co.jp/fc/rss.xml http://dailynews.yahoo.co.jp/fc/science/rss.xml http://dailynews.yahoo.co.jp/fc/computer/rss.xml)
title=("Yahoo News Topics" "Yahoo News Science" "Yahoo News Computer")

if [ -d "~/.rss" ] ; then
	mkdir ~/.rss && cd ~/.rss
else
	cd ~/.rss
fi

getrssfeed(){
	i=0
	while (( i < 3 ))
	do
		wget ${url[$i]}
		mv rss.xml $i.xml
		i=`expr $i+1`
	done
}

readrss(){
	i=0
	while (( $i < 3 ))
	do
		echo ${title[$i]}
		cat $i.xml| grep -e "<title.*" |sed  "1,2d" |sed "s/<[^>]*>//g" |sed  "s/（.*）//g" |sed "s/\&amp;/＆/g"|grep -ne ".*" |head -n 10 
		i=`expr $i+1`
	done
}

del(){
	rm -rf ~/.rss/*
}

while true;
do
	getrssfeed
	clear
	readrss
	del
	sleep 10m
done
