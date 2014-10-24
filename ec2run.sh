#!/bin/bash
BASEDIR=$(dirname $0)
export RUBYLIB=$BASEDIR
ruby -rec2info.rb -e "puts EC2Info.live(true)"
