#!/bin/bash

if [ -z "$OS_USERNAME" ]; then
echo "Please enter your OpenStack username : "
read -r OS_USERNAME
export OS_USERNAME=$OS_USERNAME
fi

if [ -z "$OS_PROJECT_NAME" ]; then
echo "Please enter your OpenStack Project Name : "
read -r OS_PROJECT_NAME
export OS_PROJECT_NAME=$OS_PROJECT_NAME
fi

if [ -z "$OS_PROJECT_ID" ]; then
echo "Please enter your OpenStack Project ID : "
read -r OS_PROJECT_ID
export OS_PROJECT_ID=$OS_PROJECT_ID
fi


if [ -z "$OS_PASSWORD" ]; then
echo "Please enter your OpenStack Password: "
read -sr OS_PASSWORD
export OS_PASSWORD=$OS_PASSWORD
fi

export OS_TENANT_ID=$OS_PROJECT_ID
export OS_TENANT_NAME=$OS_PROJECT_NAME

# used for mapping ssh key files.
if [ -d "/root/.ssh2" ]; then
	scp -r /root/.ssh2 /root/.ssh
	chown root:root /root/.ssh
	chmod 0700 /root && chmod -R 0600 /root/.ssh
fi

#exporting more usefull shell for bash.
export PS1="\[\033[1;90m\][\$(date +%H%M)]\[\033[1;92m\][\[\033[1;31m\]\$OS_TENANT_NAME - \u\[\033[1;92m\]:\[\033[1;37m\]\w\[\033[1;92m\]]\[\033[33m\]\$(parse_git_branch) \[\033[1;92m\]$\[\033[0m\] "

#exporting updated path
export PATH=$PATH:/root/.conduit/bin

function typewriter
{
    text="$1"
    delay="$2"

    for i in $(seq 0 $(expr length "${text}")) ; do
        echo -ne "\033[1;34m${text:$i:1}\033[1;0m"
        sleep ${delay}
    done
}

function typewriter2
{
    text="$1"
    delay="$2"

    for i in $(seq 0 $(expr length "${text}")) ; do
        echo -ne "\033[1;97m${text:$i:1}\033[1;0m"
        sleep ${delay}
    done
}

cat > /root/.bashrc <<'endmsg'
LS_OPTIONS="--color=auto"
alias ls="ls $LS_OPTIONS"
alias vi="vim"
test
parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
endmsg

#fork new shell which contain set variables.
if [ "$1" ]; then
	exec ssh-agent /bin/bash -c "$1"
	#exec ssh-agent /bin/zsh -c "$1"
else
        typewriter2  "The" .04
	typewriter  " Future " .04
	typewriter2  "is now" .04
	typewriter  "!" .04
	echo
	exec ssh-agent /bin/bash --rcfile /root/.bashrc
	#exec ssh-agent /bin/zsh
fi
