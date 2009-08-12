#!/bin/sh

menu(){
#wget http://menu.2ch.net/bbsmenu.html
#cat bbsmenu.html |grep -e "<BR><BR><B>" |nkf -w |sed "s/<[^>]*>//g" |grep -n -e ".*"

#array menulist[,]



echo "1:ニュース速報 2:ニュース速報+ 3:Linux q:quit"
read no
case  ${no} in 
	1)
		url=http://tsushima.2ch.net/news
	;; 
	2)
		url=http://mamono.2ch.net/newsplus
	;;
	3)
		url=http://pc11.2ch.net/linux
	;;
	q)
		del
		exit 0
	;;
esac
reget
}

geturl(){
dif=0
lis=10
while true;
do
	cat  subject.txt | head -n ${lis} |grep -n "[0-9]" | nkf -w
	echo "m)more o)operation q)quit" 
	read number
	if [ ${number} = "q" ] ; then 
		del
		exit 0
	elif [ ${number} = "m" ] ; then
		clear
		lis=`expr ${lis} + 10`
	elif [ ${number} = "o" ] ; then
		operation
	else 
		cat subject.txt | head -n $lis|grep -n "[0-9]"| grep -e "^${number}:" |nkf -w  |sed "s/^${number}://g">> list.txt
		dat=`grep -n -e  "[0-9]*\.dat" subject.txt |head -n ${lis} |nkf -w |grep -e "^${number}:" |grep "[0-9]*\.dat" |sed -e "s/\.[^.]*//g" -e "s/${number}://g"` 
		datdata=${dat}.dat
		wget ${url}/dat/${datdata}
		clear
		echo ${url}/dat/${datdata} >>  daturl.txt
		break 1
	fi
done
	readdat ${datdata}
}

reget(){
if [ -f "subject.txt" ] ; then
	rm subject.txt
fi
	wget ${url}/subject.txt
	clear
	geturl
}

readdat(){
if [ ${dif} -gt '0' ] ; then 
	cat ${datdata} |nkf -w |sed "s/^[^0-9]*//g"|grep -n "[0-9]"|tail -n ${dif} | sed  "s/<br>\|ID:[0-9a-zA-Z/+-]*/\n/g"|sed "s/<[^>]*>\|BE:.*\.gif//g" |sed "s/&gt;/>/g" | sed "s/&lt;/</g" |lv
else
	cat ${datdata} |nkf -w |sed "s/^[^0-9]*//g"|grep -n "[0-9]"| sed  "s/<br>\|ID:[0-9a-zA-Z/+-]*/\n/g"|sed "s/<[^>]*>\|BE:.*\.gif//g" |sed "s/&gt;/>/g" |sed "s/&lt;/</g" |lv
fi
	operation
}

reload(){
	dif=0
	line=`wc -l ${datdata} |sed "s/ [.0-9a-zA-Z]*//g"`
	rm ${datdata}
	wget ${url}/dat/${datdata}
	road=`wc -l ${datdata} |sed "s/ [.0-9a-zA-Z]*//g"`
	dif=`expr ${road} - ${line} + 1`
	readdat ${datdata} ${dif}
}
	
del(){
if [ -f "subject.txt" ] ; then
	rm subject.txt*
fi
if [ -f "live.html" ] ; then
	rm live.html*
fi
if [ -f "daturl.txt" ] ; then
	rm daturl.txt*
fi
if [ -f "list.txt" ] ; then
	rm list.txt
fi
	rm *.dat*
}

showlist(){
	cat list.txt |grep -n "[0-9]"
	dif=0
	read number
	dat=`grep -n "[0-9]" daturl.txt|grep -e "^${number}:"|sed -e "s/${number}://g"`
	url=`echo ${dat}|sed "s/\/dat\/[0-9]*\.dat//g"`
	datdata=`echo ${dat} |sed -e "s/.*\/dat//g" -e "s/^.//g"`
	reload ${datdata}
}
	
all(){
	dif=0
	readdat ${datdata} ${dif}
}

operation(){
echo "a)view all ress r)reload the thred R)get a new subject g)see subject l)list m)goto menu q)quit"
read opera
	case ${opera} in
		a)
			if [ -f "${datdata}" ] ; then
				all
			else 
				operation
			fi
		;;
		c)
			clear
			operation
		;;
		R)
			reget
		;;
		g)
			geturl
		;;
		l)
			if [ -f "list.txt" ] ; then
				showlist
			else
				operation
			fi
		;;
		r)
			reload
		;;
		m)
			menu
		;;
		q)
			del
			exit 0
		;;
		*)
			operation
		;;
	esac
}

menu
