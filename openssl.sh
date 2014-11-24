#!/bin/bash
#===================================================================================
#
# FILE: openssl.sh
#
# USAGE: ./openssl.sh
#
# DESCRIPTION:  Create the key and csr file  in the separate folder
#
# REQUIREMENTS: openssl 
# AUTHOR: Mr. Ahamed Yaser Arafath MK 
# VERSION: 0.0
# CREATED: 24.11.2014 - 14:30:00
# REVISION: Nil
#===================================================================================

if [ $# -ne 0 ]; then
	echo " No Arguments required, Please configure the openssl.conf file alone"
	echo " Usage: ./openssl.sh "
	exit 1
fi 

if [ -z openssl.conf ]; then
	echo " openssl.conf is not found, please get it form github"
	exit 1 # exit on error
else
	source openssl.conf
fi

if ! type "openssl" >& /dev/null ; then
	echo " Please install openssl and proceed forward"
	exit 1 	# exit on error
fi

#if [ "x$Common_Name" == "x" -o "x$Email_address" = "x" ];then

if [ -z "$Country"  -o -z "$State" -o -z "$Location" -o -z "$Organization_Name" -o -z "$Organizational_Unit_Name" -o -z "$Common_Name" -o -z "$Email_address" ];then
	echo " Sorry Country/State/Location/Organization_Name/Organizational_Unit_Name/Common_Name/Email_address should not be empty, please configure the openssl.conf"
	exit 1 	# exit on error	
fi

mkdir $Common_Name > /dev/null
if [ $? -ne 0 ];then
	echo " $Common_Name Directory not created, please check whether the user has permission to create folder in the present directory \
	 		or already exists"
	echo " Please remove the $Common_Name directory manually "
	exit 1
else
	echo " $Common_Name Directory created successfully"
fi

cd $Common_Name > /dev/null
if [ $? -ne 0 ];then
	echo " Error in changing the directory" 
fi

openssl genrsa -out $Common_Name.key 2048 >& /dev/null
if [ $? -ne 0 ];then
	echo " Error in creating the genrsa key file"
	exit 1
else
	echo " genrsa key is generated successfully"	
fi

#echo $Country $State $Location $Organization_Name $Organizational_Unit_Name $Common_Name $Email_address
echo -e "\t\tCountry = $Country
		State= $State
		Location= $Location
		Organization Name= $Organization_Name
		Organizational Unit Name= $Organizational_Unit_Name
		Common Name = $Common_Name
		Email_address = $Email_address
		Password = $Password"
echo -e -n " Above Arguments are right means, Press Y or N : "
read key
if [ -z $key ];then
	key=Y
fi
if [ $key = "N" ];then
	echo " Aborting the ssl key generation"
	cd - > /dev/null
	if [ $? -ne 0 ];then
		echo " Error in changing the directory" 
	fi
	rm -rf $Common_Name
	if [ $? -ne 0 ];then
		echo " Error in removing the directory, please make sure delete the folder which is created by this script " 
	fi
	exit 1
fi

openssl req -new -key $Common_Name.key -out $Common_Name.csr -passin pass:$Password \
    -subj "/C=$Country/ST=$State/L=$Location/O=$Organization_Name/OU=$Organizational_Unit_Name/CN=$Common_Name/emailAddress=$Email_address" >& /dev/null
if [ $? -ne 0 ];then
	echo " Error in creating the csr file"
else
	echo " $Common_Name.csr file is generated successfully"	
fi
