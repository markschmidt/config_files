if [ -f ~/.bashrc ]; then
   source ~/.bashrc
fi

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
[[ -f ~/.bashrc ]] && source ~/.bashrc # ghcup-env
export PATH="/usr/local/opt/node@14/bin:$PATH"

eval "$(/opt/homebrew/bin/brew shellenv)"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/mschmidt/.lmstudio/bin"
# End of LM Studio CLI section

