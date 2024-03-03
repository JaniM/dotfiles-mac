#!/usr/bin/env zsh

set -euo pipefail

if [ ! -d ~/Library/Fonts/Noto ]; then
  echo "Downloading Noto..."
  curl -L --output /tmp/Noto.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/Noto.zip
  echo "Extracting to /tmp/Noto..."
  unzip /tmp/Noto.zip -d /tmp/Noto > /dev/null
  rm /tmp/Noto.zip

  echo "Moving /tmp/Noto to ~/Library/Fonts"
  mv /tmp/Noto ~/Library/Fonts
fi

