#!/bin/bash
if ! [ -e /usr/include/sysexits.h ] ; then
curl https://raw.githubusercontent.com/Sky-Bly/ps1shrug/master/sysexits.h >  ~/.sysexits.h
fi
