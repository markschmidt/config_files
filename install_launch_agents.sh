#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
for name in $DIR/launch_agents/*; do
  new_agent=~/Library/LaunchAgents/$(basename $name)
  cp -vv $name $new_agent

  launchctl unload $new_agent
  launchctl load $new_agent
done
