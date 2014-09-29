#!/bin/bash
environment_name='STAGING'
my_environment='ToutStaging'
hipchat_room="Engineering"
if [ "$1" == "staging" ]
then
  environment_name='STAGING'
  my_environment='ToutStaging'
elif [ "$1" == "production" ]
then
  environment_name='PRODUCTION'
  my_environment='ToutProduction'
fi
ruby -r./eytrans -e "puts EYTrans.live('$my_environment' ,true)"
