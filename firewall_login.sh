#!/bin/bash

FIREWALL_IP="http://172.16.1.1:1000/"
HEADERS="-H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:69.0) Gecko/20100101 Firefox/69.0' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' -H 'Accept-Language: en-US,en;q=0.5' --compressed -H 'Content-Type: application/x-www-form-urlencoded' -H 'DNT: 1' -H 'Connection: keep-alive' -H 'Upgrade-Insecure-Requests: 1'"

flogin() {

	USERNAME="$1"
	PASSWD="$2"

	# first ask for login page
	LOGIN_PAGE=$(curl $FIREWALL_IP/login?)

	MAGIC_VALUE=$(echo $LOGIN_PAGE | grep -oP '(?<=<input type="hidden" name="magic" value=")[0-9a-z]+(?=">)')

	echo "Logging with USER = $USERNAME, PASSWD = $PASSWD, MAGIC = $MAGIC_VALUE"

	# login with $USERNAME $MAGIC $PASSWD
	RESULT=$(curl $FIREWALL_IP \
		-H "referer: $FIREWALL_IP/login?" \
		--data "4Tredir=http%3A%2F%2F172.16.1.1%3A1000%2Flogin%3F&magic=$MAGIC_VALUE&username=$USERNAME&password=$PASSWD")

}

flogout() {
	
	curl "$FIREWALL_IP/logout?"
}

fkeepalive() {

	curl "$FIREWALL_IP/keepalive?0000000000000000000"
}

case "$1" in
	login)
		flogin $2 $3
		;;
	logout)
		flogout
		;;
	keepalive)
		fkeepalive
		;;
	*)
		echo "Usage: $0 {login|logout|keepalive}"
esac
