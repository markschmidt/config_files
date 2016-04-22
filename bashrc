parse_git_dirty() {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit, working directory clean" ]] && echo "*"
}
parse_git_branch() {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/(\1$(parse_git_dirty))/"
}
check_for_bg_vim() {
  jobs | grep -q vim && echo "[vim]"
}
export PS1='\[\033[01;32m\]\u\[\033[01;34m\]:\w\[\033[31m\] $(parse_git_branch)\[\033[33m\]$(check_for_bg_vim)\[\033[01;34m\]$\[\033[00m\] '

push_repo_to_remote() {
  folder_name=${PWD##*/}
  if [ ! -e .git ]; then echo "$folder_name is not a git repository"; fi
  ssh mark@markschmidt.net "mkdir projects/$folder_name.git && cd projects/$folder_name.git && git init --bare" &&
  git remote add origin mark@markschmidt.net:projects/$folder_name.git &&
  git push -u origin master
}

ssh-me() {
  ssh xing-mark.schmidt@$1
}

ssh-pw() {
  ssh -o PubkeyAuthentication=no xing-mark.schmidt@$1
}

tag() { alias $1="cd $PWD"; }
ptag() { alias $1="cd $PWD"; echo "alias $1=\"cd $PWD\"" >> ~/.bash_aliases; }

export PATH=/opt/local/bin:$PATH
export PATH=/usr/local/mysql/bin:$PATH
export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/sbin:$PATH
export PATH=$HOME/.bin:$PATH
export PATH=$PATH:/usr/local/opt/go/libexec/bin

export EDITOR=vim

export EVENT_NOKQUEUE=1
export ARCHFLAGS="-arch x86_64"
export CLICOLOR=1

# hacks from http://blog.macromates.com/2008/working-with-history-in-bash/
export HISTCONTROL=erasedups
export HISTSIZE=10000
shopt -s histappend

# Profile integration test specific settings
export BACKEND_HOST=main-mark-schmidt.env.xing.com
export REST_BASE_URL=http://$BACKEND_HOST:3007/rest

# Brew Bash shell command completion
if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
fi

# local aliases
if [ -f $HOME/.aliases ]; then source $HOME/.aliases; fi
eval "$(rbenv init --no-rehash -)"
(rbenv rehash &) 2> /dev/null
