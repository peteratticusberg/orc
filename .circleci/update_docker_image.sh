#!/bin/bash
command_name="$1" # the idea here is that each command will have its own docker image

commands_dir=".circleci/commands"
command_exists="$(ls "$commands_dir" | grep "$command_name")"
if [ -z "$command_exists" ]; then
  echo "Unrecognized command: $command_name"
  exit 1
fi

dockerfile="$commands_dir/$command_name.dockerfile"
image_tag="coinsrepo/$command_name-command"

docker build . -t "$image_tag" -f "$dockerfile"
docker push $image_tag