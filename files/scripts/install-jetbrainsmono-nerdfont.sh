#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

DOWNLOAD_PATH="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip"
FILE_NAME=$(basename ${DOWNLOAD_PATH})
TARGET_PATH="/usr/share/fonts"
PWD=$(pwd)

# Your code goes here.
echo "Install $FILE_NAME"

echo "Downloading $FILE_NAME"
curl -OL $DOWNLOAD_PATH

if [ -d "$TARGET_PATH" ]; then
  echo "Extracting $FILE_NAME"
  unzip $FILE_NAME -d $TARGET_PATH
  echo "Done. Cleaning up."
  rm $FILE_NAME
fi
