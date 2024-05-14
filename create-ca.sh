#!/bin/bash

# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

# create-ca.sh 

DIR=$(dirname $(realpath $0))
OPENSSL_CNF=$DIR/openssl-iam-roles-anywhere.cnf
KEY_LENGTH=4096
DAYS=1825

CA_SUBJ="/C=CN/ST=Beijing/L=Beijing/O=PKI/OU=Cloud/CN=CA"

if [ ! -z "$1" ]; then
    CA_SUBJ=$1
fi


echo "Create CA:"
echo "--------------------------------------------------"
echo "CA_SUBJ=$CA_SUBJ"
echo "--------------------------------------------------"
echo "Hit <Enter> to continue or <Crtl+C> to abort"
read

if [ -d CA ]; then
    echo "directory CA exists already. Remove or rename it and run the script again."
    exit 1
fi

mkdir CA

cd CA
mkdir {certs,csrs,keys,pfx}
echo "unique_subject = yes" > index.txt.attr

touch index.txt
echo 1000 > serial
echo 1000 > crlnumber

openssl genrsa -out rootCA.key $KEY_LENGTH
openssl req -config $OPENSSL_CNF -x509 -new -nodes -key rootCA.key \
    -sha256 -days $DAYS -out rootCA.crt \
    -subj "$CA_SUBJ"
openssl x509 -text -noout -in rootCA.crt

echo "CA created"
