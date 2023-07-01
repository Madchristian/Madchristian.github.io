#!/bin/bash

DIRECTORY_TO_OBSERVE="/home/christian/Madchristian.github.io/_posts"      # might want to change this
BUILD_SCRIPT_LOCATION="/home/christian/Madchristian.github.io"  # the location of your Jekyll build script

function block_for_change {
  inotifywait --recursive \
              --event modify,move,create,delete \
              $DIRECTORY_TO_OBSERVE
}

function build {
  JEKYLL_ENV=production /home/christian/gems/bin/bundle exec /home/christian/gems/bin/jekyll build
}



# First time build
build

# Then wait for any changes in the observed directory, and build again
while block_for_change; do
  build
done
