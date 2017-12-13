parse_git_dirty() {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit, working "* ]] && echo "*"
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

ssh-ec2() {
  ssh -i ~/.ssh/sc-dev.pem ec2-user@$1
}

find-file() {
  find . -name "$1" 2> /dev/null
}

edit-in-path() {
  vim `which $1`
}

search-in-git-history() {
  git rev-list --all | xargs git grep "$1"
}

encrypt-file() {
  gpg -r mark@markschmidt.net --output "$1.gpg" -e "$1"
}

encrypt-file-symmetric() {
  gpg -c --output "$1.gpg" "$1"
}

tag() { alias $1="cd $PWD"; }
ptag() { alias $1="cd $PWD"; echo "alias $1=\"cd $PWD\"" >> ~/.bash_aliases; }

export GOPATH=$HOME/go

export PATH=/opt/local/bin:$PATH
export PATH=/usr/local/mysql/bin:$PATH
export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/sbin:$PATH
export PATH=$HOME/.bin:$PATH
export PATH=$GOPATH/bin:$PATH
export PATH=$PATH:/usr/local/opt/go/libexec/bin
export PATH="$HOME/.rbenv/bin:$PATH"
export PATH=$PATH:~/code/baking_workspace/deployr/amibaking/baking-container

export EDITOR=vim

export EVENT_NOKQUEUE=1
export ARCHFLAGS="-arch x86_64"
export CLICOLOR=1

export HISTCONTROL=ignoredups:erasedups
export HISTSIZE=100000
shopt -s histappend

#export HISTTIMEFORMAT="%s "
#export HISTTIMEFORMAT="%F %T "
#export HISTTIMEFORMAT=""
#export PROMPT_COMMAND="$PROMPT_COMMAND"'echo $$ $USER\
#export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND ; }"'echo $$ $USER \
               #"$(history 1)" >> ~/.bash_eternal_history'
PROMPT_COMMAND='echo "$(date "+%Y-%m-%d.%H:%M:%S") $$ $USER $HOSTNAME $(pwd) $(history 1)" >> ~/.bash_eternal_history2;'

# Profile integration test specific settings
export BACKEND_HOST=main-mark-schmidt.env.xing.com
export REST_BASE_URL=http://$BACKEND_HOST:3007/rest

if [[ "$OSTYPE" == "darwin"* ]]; then
  # Brew Bash shell command completion
  if [ -f $(brew --prefix)/etc/bash_completion ]; then
      . $(brew --prefix)/etc/bash_completion
  fi
fi


if [ -f $HOME/.bin/tmuxinator.bash ]; then source $HOME/.bin/tmuxinator.bash; fi

# local aliases
if [ -f $HOME/.aliases ]; then source $HOME/.aliases; fi
eval "$(rbenv init --no-rehash -)"
(rbenv rehash &) 2> /dev/null


export NVM_DIR=$HOME/.nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

if [ -f $HOME/.bashrc.d/source_bashrcdir ]; then source $HOME/.bashrc.d/source_bashrcdir; fi

if which klam-ext > /dev/null; then
    eval "$(env klam-ext bash-integration)";
fi

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

if [ -f $HOME/.profile ]; then source ~/.profile; fi
