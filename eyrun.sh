#!/bin/bash
environment_name='STAGING'
my_environment='ToutStaging'
hipchat_room="Engineering"
if [ "$1" == "staging" ]
then
  environment_name='STAGING'
  my_environment='ToutStaging'
elif [ "$1" == "linkerproduction" ]
then
  environment_name='LINKERPRODUCTION'
  my_environment='LinkerProduction'
elif [ "$1" == "linkerstaging" ]
then
  environment_name='LINKERSTAGING'
  my_environment='LinkerStaging'
elif [ "$1" == "imager" ]
then
  environment_name='ToutImagerProduction'
  my_environment='ToutImagerProduction'
elif [ "$1" == "production" ]
then
  environment_name='PRODUCTION'
  my_environment='ToutProduction'
fi
ruby -r./eytrans -e "puts EYTrans.live('$my_environment' ,true)"
