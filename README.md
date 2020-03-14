# ps1shrug
A PS1 that returns the exit code of your last command from bash, PS1 also shows git branch and status

Can quickly be added to your .bashrc/.bash_profile as below
# check/populate sysexits.h
/bin/bash <(curl -sL https://raw.githubusercontent.com/Sky-Bly/ps1shrug/master/checkexits.sh)
# add entries to bashrc
cp -iav .bashrc{,$(date -I)}
curl -sL https://raw.githubusercontent.com/Sky-Bly/ps1shrug/master/bashrc  >> ~/.bashrc
