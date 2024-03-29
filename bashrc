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

journal() {
  if [ -z "$1" ]; then
    local date=`date +"%Y-%m-%d"`
  else
    local date=`date -v$1d +"%Y-%m-%d"`
  fi
  vim ~/Dropbox/journal/$date.md
}

export GOPATH=$HOME/go

export PATH=/opt/local/bin:$PATH
export PATH=/usr/local/mysql/bin:$PATH
export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/sbin:$PATH
export PATH=$HOME/.bin:$PATH
export PATH=$HOME/.local/bin:$PATH
export PATH=$GOPATH/bin:$PATH
export PATH=$PATH:/usr/local/opt/go/libexec/bin
export PATH="$HOME/.rbenv/bin:$PATH"
export PATH=$PATH:~/code/baking_workspace/deployr/amibaking/baking-container
export PATH="$HOME/.cabal/bin:$HOME/.ghcup/bin:$PATH"
# use node14 as default
export PATH=/usr/local/opt/node@14/bin:$PATH

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

# check if any java is installed
if command -v /usr/libexec/java_home &> /dev/null && /usr/libexec/java_home -F &> /dev/null; then
  export JAVA_8_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_121.jdk/Contents/Home/
  export JAVA_11_HOME=$(/usr/libexec/java_home -v11)

  alias java8='export JAVA_HOME=$JAVA_8_HOME'
  alias java11='export JAVA_HOME=$JAVA_11_HOME'
 
  # default to Java 11
  java11
fi


if [[ "$OSTYPE" == "darwin"* ]]; then
   #Brew Bash shell command completion
  if [ -f $(brew --prefix)/etc/bash_completion ]; then
      . $(brew --prefix)/etc/bash_completion
  fi
fi


#if [ -f $HOME/.bin/tmuxinator.bash ]; then source $HOME/.bin/tmuxinator.bash; fi

# local aliases
if [ -f $HOME/.aliases ]; then source $HOME/.aliases; fi
if command -v rbenv &> /dev/null; then
  eval "$(rbenv init --no-rehash -)"
  (rbenv rehash &) 2> /dev/null
fi



#export NVM_DIR=$HOME/.nvm
#[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

if [ -f $HOME/.bashrc.d/source_bashrcdir ]; then source $HOME/.bashrc.d/source_bashrcdir; fi

#if which klam-ext > /dev/null; then
    #eval "$(env klam-ext bash-integration)";
#fi

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

if [ -f $HOME/.profile ]; then source ~/.profile; fi
if [ -f $HOME/.ghcup/env ]; then source ~/.ghcup/env; fi
if [ -f $HOME/.bash_export_secrets ]; then source ~/.bash_export_secrets; fi

if command -v starship &> /dev/null; then
  function vim_bg_checker(){
      if jobs | grep -q vim ; then
          export VIM_IN_BG=true
      else
          export VIM_IN_BG=false
      fi
  }
  starship_precmd_user_func="vim_bg_checker"
  eval "$(starship init bash)"
fi
