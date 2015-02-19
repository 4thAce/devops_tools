#!/bin/sh


ey ssh "sudo kill -9 22950; " -e ToutProduction --utilities=Resque16
ey ssh "sudo kill -9 32416; " -e ToutProduction --utilities=Resque20
ey ssh "sudo kill -9 4838; " -e ToutProduction --utilities=Resque25

