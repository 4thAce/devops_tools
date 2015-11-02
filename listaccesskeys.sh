#!/bin/bash
# List all the AWS Access Keys for users in the $1 account

if [ "$1" == "test2" ]
then
    . ${HOME}/.bash_aws-dev
else
    . ${HOME}/.bash_aws-prod
fi

# aws doesn't always return the same number of fields
ARR7=`aws iam list-users --output=text | awk '{print $7}'`
ARR6=`aws iam list-users --output=text | awk '{print $6}' |grep -v 'AIDA'`
for user in ${ARR7}; do
    if [ "${user}xxx" != "xxx" ] ; then
      AK=`aws iam list-access-keys --user-name=${user} --output=text | awk '{print $2}'`
      echo ${user} ${AK}
    fi
done

for user in ${ARR6}; do
    if [ "${user}xxx" != "xxx" ] ; then
      AK=`aws iam list-access-keys --user-name=${user} --output=text | awk '{print $2}'`
      echo ${user} ${AK}
    fi
done
    
