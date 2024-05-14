#!/bin/bash

# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

# setup.sh

chmod +x *.sh

BASENAME="RolesAnywhere"
TIMESTAMP=$(date +%Y%m%d%H%M%S)

echo "creating iam-anywhere.rc"
cp /dev/null iam-anywhere.rc
echo "BASENAME=$BASENAME" >> iam-anywhere.rc
echo "TIMESTAMP=$TIMESTAMP" >> iam-anywhere.rc
echo "done"

echo "creating CA..."
./create-ca.sh
echo "done"

echo "installing credential helper tool..."
curl https://rolesanywhere.amazonaws.com/releases/1.0.4/X86_64/Linux/aws_signing_helper -o aws_signing_helper
chmod +x aws_signing_helper
echo "done"

