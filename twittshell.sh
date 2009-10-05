#!/bin/bash

ID=hogehoge
PASS=hogehoge

main(){
echo "1:TimeLine 2:Post q:Exit"
read opera
	case $opera in
		1)
			timeline
		;;
		2)
			post
		;;
		q)
			quit	
		;;
		*)
			main
		;;
	esac
}

timeline(){
	clear	
	curl -s -O --basic --user "$ID:$PASS" "http://twitter.com/statuses/friends_timeline.rss" 
	nkf -w --numchar-input friends_timeline.rss > ftl.rss
	cat ftl.rss  |grep "title" | sed "s/<[^>]*>//g"
	rm friends_timeline.rss 
	rm ftl.rss
	main
}

post(){
	
	echo "input your messeages: "
	read mess
	curl -s --basic --user "$ID:$PASS" --data-ascii "status=$mess" "http://twitter.com/statuses/update.json"
	clear
	timeline
}

quit(){
	exit 0
}

while true;
do
	main
done


