fortune | cowsay -f dragon

# get current branch in git repo
function parse_git_branch() {
    BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
    if [ ! "${BRANCH}" == "" ]
    then
        STAT=`parse_git_dirty`
        echo "[${BRANCH}${STAT}]"
    else
        echo ""
    fi
}
 
# get current status of git repo
function parse_git_dirty {
    status=`git status 2>&1 | tee`
    dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
    untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
    ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
    newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
    renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
    deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
    bits=''
    if [ "${renamed}" == "0" ]; then
        bits=">${bits}"
    fi
    if [ "${ahead}" == "0" ]; then
        bits="*${bits}"
    fi
    if [ "${newfile}" == "0" ]; then
        bits="+${bits}"
    fi
    if [ "${untracked}" == "0" ]; then
        bits="?${bits}"
    fi
    if [ "${deleted}" == "0" ]; then
        bits="x${bits}"
    fi
    if [ "${dirty}" == "0" ]; then
        bits="!${bits}"
    fi
    if [ ! "${bits}" == "" ]; then
        echo " ${bits}"
    else
        echo ""
    fi
}
 
function nonzero_return() {
    RETVAL=$?
    # [ $RETVAL -ne 0 ] && 
    echo "[$RETVAL]"
}
 
 
############################################
# Modified from emilis bash prompt script
# from https://github.com/emilis/emilis-config/blob/master/.bash_ps1
#
# Modified for Mac OS X by
# @corndogcomputer
###########################################
# Fill with minuses
# (this is recalculated every time the prompt is shown in function prompt_command):
fill="--- "
 
reset_style='\[\033[00m\]'
status_style=$reset_style'\[\033[00;90m\]' # gray color; use 0;37m for lighter color
prompt_style=$reset_style
command_style=$reset_style #'\[\033[1;29m\]'01; #  black

# Prompt variable:
tt="\[\e[00;31m\][\[\e[m\]\[\e[00;31m\]\t\[\e[m\]\[\e[00;31m\]]\[\e[m\]"
uh="\[\e[00;32m\][\[\e[m\]\[\e[00;32m\]\u\[\e[m\]\[\e[00;37m\]@\[\e[m\]\[\e[00;34m\]\h\[\e[m\]\[\e[00;32m\]]\[\e[m\]"
wd="\[\e[00;34m\][\[\e[m\]\[\e[00;34m\]\w\[\e[m\]\[\e[00;34m\]]\[\e[m\]"
et="\[\e[00;35m\]\[\e[00;35m\]\`nonzero_return\`\[\e[m\]\[\e[m\]"
gt="\[\e[33m\]\`parse_git_branch\`\[\e[m\]"
pt="\[\e[00;32m\]\\$\[\e[m\]"
tag="$tt$wd$et$gt$pt"
PS1="$status_style"'$fill \t\n'"$prompt_style$tag$command_style "
 
# Reset color for command output
# (this one is invoked every time before a command is executed):
trap 'echo -ne "\033[0m"' DEBUG
 
function prompt_command {
    # create a $fill of all screen width minus the time string and a space:
    let fillsize=${COLUMNS}-9
    fill=""
    while [ "$fillsize" -gt "0" ]
    do
        fill="-${fill}" # fill with underscores to work on
        let fillsize=${fillsize}-1
    done

    # If this is an xterm set the title to user@host:dir
    case "$TERM" in
    xterm*|rxvt*)
        bname=`basename "${PWD/$HOME/~}"`
        echo -ne "\033]0;${bname}: ${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"
        ;;
    *)
    	;;
    esac
}
 
PROMPT_COMMAND=prompt_command

