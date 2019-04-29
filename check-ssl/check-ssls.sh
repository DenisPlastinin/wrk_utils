#!/bin/bash
#  
#EXP_DATE=864000   # 10 day = 864000 sec
List_Sites="list_of_sites.list"
EXP_DATE_DAYS=($EXP_DATE/86400) # sec to days
Right_frase="Certificate will expire"

if [ -n "$1" ] # check first parm hostName
then # если что то подали в качестве первого параметра
	EXP_DATE="$1";
else # если ничего не подали 10 day
	EXP_DATE=10;
fi

EXP_DATE_SEC=$(($EXP_DATE*86400))

while read SITE;
	do exp_result=$(echo | openssl s_client -servername $SITE -connect $SITE:443 2>/dev/null | openssl x509 -noout -checkend $EXP_DATE_SEC);
	if [ "$exp_result" = "Certificate will expire"  ]
	then	
		echo -e "SSL for $SITE \e[31m$exp_result\e[0m less $EXP_DATE days \e[31mNOT GOOD\e[0m";
	else
		echo -e "SSL for $SITE is \e[32mGOOD\e[0m";
#		echo -e "SSL for $SITE will be \e[32m$exp_result\e[0m less $EXP_DATE_DAYS days \e[32mGOOD\e[0m";
	fi
done < $List_Sites;

#echo $(($EXP_DATE/86400))
#secs=100000
#printf '%dh:%dm:%ds\n' $(($secs/3600)) $(($secs%3600/60)) $(($secs%60))

