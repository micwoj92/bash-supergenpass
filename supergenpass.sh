#!/usr/bin/env bash

################################################################################

default_password_length="10"	### Default is 10. It can be overwritten on an individual basis by adding the custom length as a second argument after the domain when invoking the command.
default_hashing_algorithm="md5"		### Default is "md5". Alternate value is "sha512". It can be overwritten with the third argument.

################################################################################

domain=$(echo $1 | tr A-Z a-z)
length=${2:-$default_password_length}
hashing_algorithm=${3:-$default_hashing_algorithm}

read -srp 'Password: ' master_password

hash=$master_password:$domain

i=0
while true
do
	hash=$(echo -n "$hash" | openssl "$hashing_algorithm" -binary | base64 -w0 | tr +/= 98A)
	i=$(($i + 1))
	if [ $i -lt 10 ]
	then
		continue
	fi
	valid=$(echo "${hash:0:$length}" | egrep '^[a-z]' | egrep '.[A-Z]' | egrep '.[0-9]' )
	if [ "$valid" != "" ]
	then
		break
	fi
done
echo ${hash:0:$length}
