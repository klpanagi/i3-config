#!/usr/bin/sh

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DEST="$HOME/.i3"

if [ -d "$DEST" ]; then
  echo -e "[x] - Directory $DEST allready exists"
else
  ln -sT $SCRIPT_DIR $DEST
  echo -e "[*] - Created symlink!"
fi
