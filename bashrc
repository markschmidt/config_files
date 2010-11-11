# MacPorts Installer addition on 2010-05-03_at_13:23:32: adding an appropriate PATH variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
# Finished adapting your PATH environment variable for use with MacPorts.

# MacPorts Bash shell command completion
if [ -f /opt/local/etc/bash_completion ]; then
    . /opt/local/etc/bash_completion.d/git
fi

function parse_git_dirty {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "*"
}
function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/(\1$(parse_git_dirty))/"
}
export PS1='\[\033[01;32m\]\u\[\033[01;34m\]:\w\[\033[31m\] $(parse_git_branch)\[\033[01;34m\]$\[\033[00m\] '

alias cdr='cd /Users/mark.schmidt/code/rails-app && eval `bin/xing_env`'
alias cds='cd /Users/mark.schmidt/code/dynamic-seo-directory && PATH=/Users/mark.schmidt/Downloads/redis-2.0.2:$PATH'

tag() { alias $1="cd $PWD"; }
ptag() { alias $1="cd $PWD"; echo "alias $1=\"cd $PWD\"" >> ~/.bash_aliases; }

export PATH=/opt/local/bin:$PATH
export PATH=/usr/local/mysql/bin:$PATH
export PATH=/usr/local/ruby187pl300patched/bin:$PATH

export EVENT_NOKQUEUE=1
export ARCHFLAGS="-arch x86_64"
export CLICOLOR=1

# hacks from http://blog.macromates.com/2008/working-with-history-in-bash/
export HISTCONTROL=erasedups
export HISTSIZE=10000
shopt -s histappend


if [[ -s /Users/mark.schmidt/.rvm/scripts/rvm ]] ; then source /Users/mark.schmidt/.rvm/scripts/rvm ; fi
if [[ -r $rvm_path/scripts/completion ]] ; then source $rvm_path/scripts/completion ; fi
