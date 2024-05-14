#!/bin/bash

# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

# issue-cert.sh

DIR=$(dirname $(realpath $0))
OPENSSL_CNF=$DIR/openssl-iam-roles-anywhere.cnf
KEY_LENGTH=4096
DAYS=365

if [ -z "$1" ]; then
    echo "usage: $0 <cert_name>"
    exit 1
fi

CERT_NAME=$1
CERT_SUBJ="/C=CN/ST=Beijing/L=Beijing/O=IAM/OU=Anywhere/CN=$CERT_NAME"

if [ ! -z "$2" ]; then
    CERT_SUBJ=$2
fi


echo "Issue certificate:"
echo "--------------------------------------------------"
echo "CERT_NAME=$CERT_NAME"
echo "CERT_SUBJ=$CERT_SUBJ"
echo "--------------------------------------------------"
echo "Hit <Enter> to continue or <Crtl+C> to abort"
read


if [ -e CA/certs/$CERT_NAME.crt ]; then
    echo "$CERT_NAME.crt exists already, exiting"
    exit 1
fi


echo "generating RSA certificate"
openssl genrsa -out CA/keys/$CERT_NAME.key $KEY_LENGTH
openssl req -config $OPENSSL_CNF -new -key CA/keys/$CERT_NAME.key -out CA/csrs/$CERT_NAME.csr \
    -days $DAYS -subj "$CERT_SUBJ"
openssl ca -config $OPENSSL_CNF -extensions usr_cert \
    -notext -md sha256 -in CA/csrs/$CERT_NAME.csr -out CA/certs/$CERT_NAME.crt
openssl x509 -text -noout -in CA/certs/$CERT_NAME.crt

echo "Storing key and cert in PFX format:"
openssl pkcs12 -export -in CA/certs/$CERT_NAME.crt \
    -inkey CA/keys/$CERT_NAME.key -certpbe PBE-SHA1-3DES \
    -keypbe PBE-SHA1-3DES -macalg sha1 \
    -out CA/pfx/$CERT_NAME.pfx

echo "certificate issued:"
echo "key: CA/keys/$CERT_NAME.key"
echo "cert: CA/certs/$CERT_NAME.crt"
echo "pfx: CA/pfx/$CERT_NAME.pfx"
