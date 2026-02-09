#!/bin/bash

echo "STARTING: Installing additional software(s)"
yum install -y git
amazon-linux-extras install -y postgresql16 java-openjdk11
echo "FINISHED: Installing additional software(s)"
