#!/bin/sh
. "/Users/richardmagahiz/.bash_aws-$2"
for ii in `aws ec2 describe-instances --region=us-west-2 --output=text|grep $1|grep INSTANCES|awk '{print $8}'`;
do
    echo `aws ec2 describe-instances --region=us-west-2 --output=text --instance-id=$ii|grep -w Name|grep -w TAGS|cut -f3-`;
done
