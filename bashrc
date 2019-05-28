# https://github.com/Sky-Bly/ps1shrug/

# see what git --is-inside-work-tree returns
function git_tree {
    git rev-parse --is-inside-work-tree &> /dev/null
}

# check to see what branch if a git_tree
function check_git_branch {
    if git_tree ; then
    local HC=$(git rev-parse --symbolic-full-name --abbrev-ref HEAD 2> /dev/null)
    if [ "$HC" == HEAD ]
    then
        local CW=$(git name-rev --name-only HEAD 2> /dev/null)
        if [ "$CW" != undefined ]
        then echo -n "[@$CW]"
        else git rev-parse --short HEAD 2> /dev/null
        fi
    else
        echo -n "[$HC]"
       fi
    fi
}

# check git status 
function check_git_status {
    if git_tree ; then
    local stats=$(git status|tail -n 1  2> /dev/null)
    if [ -n "$status" ]
    then echo -n " [ $status ] "
    else echo -n " ![ Do you need to commit? ]! "
    fi
    fi
}



# satic set of error maps, defined by bash standards, add your own here as needed 
export emapsH="1 = Catchall for general errors\n2 = Misuse of shell builtins\n126 = Command invoked cannot execute\n127 = command not found\n128 = invalid argument to exit\n130 = script terminated by ctrl+c\n255 = exit code out of range"

#Check the return value of the last process ran and return the status through our checks and c returns to see if it matches one
check_cerror(){
  #we return the argument of this function in exit to try to pass-through any caught error codes
	argIn=$1
	cerror_found=$(egrep "\s$1\s" /usr/include/sysexits.h | awk -F'^#define' '{print $NF}')
 if ! [[ $cerror_found =  "" ]]  ; then
          echo "$cerror_found"
	  exit $argIn
        else
                checkBashMap=$(echo -e $emapsH|grep $argIn | head -n 1)
        if ! [[ $checkBashMap =~  "^$" ]] ; then
               echo $checkBashMap
	       exit $argIn
        fi
        exit $argIn
 fi
}

# export
export -f check_git_branch check_git_status git_tree check_cerror 


export PS1="\n[\$( check_cerror \$?  ) ]\n \$(if [[ \$? == 0 ]]; 
                       then echo \"\[\033[0;34m\](^‿^)\"; 
                        else echo \"\[\033[0;31m\]¯\\_(^.^)_/¯\"; 
                     fi)\
	    \[\033[00m\]
┌─[\[\e[1;30m\] \T \[\e[1;30m\]\[\e[1;34m\]\
\u@\h\[\e[1;30m\]:\[\e[0;37m\]${SSH_TTY:-}\[\e[1;32m\]\w\[\e[0;32m\] \[\e[0;32m\]\[\033[00m\]] \$(check_git_status) \$(check_git_branch) 
\[\033[00m\]\
└─> "


#  Example of shell output and inline PS1 variable printout
###┌─[ 06:34:32 sky-bly@github.com:~/ps1shrug/ ]   
###└─> echo $PS1
###\n[$( check_cerror $? ) ]\n $(if [[ $? == 0 ]]; then echo "\[\033[0;34m\](^‿^)"; else echo "\[\033[0;31m\]¯\_(^.^)_/¯"; fi) \[\033[00m\] ┌─[\[\e[1;30m\] \T \[\e[1;30m\]\[\e[1;34m\]\u@\h\[\e[1;30m\]:\[\e[0;37m\]\[\e[1;32m\]\w\[\e[0;32m\] \[\e[0;32m\]\[\033[00m\]] $(check_git_status) $(check_git_branch) \[\033[00m\]└─>
###
###[ EX_OK		0	/* successful termination */ ]
### (^‿^)	    
