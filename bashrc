# Brew Bash shell command completion
if [ -d /usr/local/etc/bash_completion.d ]; then
    . /usr/local/etc/bash_completion.d/git-completion.bash
fi

function parse_git_dirty {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "*"
}
function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/(\1$(parse_git_dirty))/"
}
export PS1='\[\033[01;32m\]\u\[\033[01;34m\]:\w\[\033[31m\] $(parse_git_branch)\[\033[01;34m\]$\[\033[00m\] '

push_this_to_remote() {
  current_branch=`git br | grep "*" | awk '{print $2}'`
  git push xws $current_branch
  git br --set-upstream $current_branch xws/$current_branch
}

function set_ruby {
  ruby_version=$1
  gemset=$2
  echo $ruby_version > .ruby-version
  echo $gemset > .rbenv-gemsets
}

push_repo_to_remote() {
  folder_name=${PWD##*/}
  if [ ! -e .git ]; then echo "$folder_name is not a git repository"; fi
  ssh mark@markschmidt.net "mkdir projects/$folder_name.git && cd projects/$folder_name.git && git init --bare" &&
  git remote add origin markschmidt.net:projects/$folder_name.git &&
  git push origin master &&
  git br --set-upstream master origin/master
}

# local aliases
if [ -f $HOME/.aliases ]; then source $HOME/.aliases; fi


tag() { alias $1="cd $PWD"; }
ptag() { alias $1="cd $PWD"; echo "alias $1=\"cd $PWD\"" >> ~/.bash_aliases; }

export PATH=/opt/local/bin:$PATH
export PATH=/usr/local/mysql/bin:$PATH
export PATH=/usr/local/bin:$PATH
export PATH=$HOME/.bin:$PATH

export EDITOR='subl -w'

export EVENT_NOKQUEUE=1
export ARCHFLAGS="-arch x86_64"
export CLICOLOR=1

# hacks from http://blog.macromates.com/2008/working-with-history-in-bash/
export HISTCONTROL=erasedups
export HISTSIZE=10000
shopt -s histappend

eval "$(rbenv init -)"
