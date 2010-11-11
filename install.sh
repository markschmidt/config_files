#!/bin/bash
for file in bash_profile bashrc gitconfig irbrc vimrc
do
  if [ -f $HOME/.$file ]
    then
    echo "creating backup for $file -> ${file}.bak"
    mv $HOME/.$file $HOME/.${file}.bak
  fi
  ln -s $HOME/config_files/$file $HOME/.$file
done
