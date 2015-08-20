#!/bin/bash
B='\033[0;34m\033[1m'
NC='\033[0m'

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 training_tarball.tar.gz test_tarball.tar.gz"
  exit
fi

if [ ! -d images ]; then
  mkdir images
fi

echo
echo -e "${B}Untaring training dataset into: ./images${NC}"
tar xvfz $1 -C ./images/ > /dev/null 2>&1

echo
echo -e "${B}Untaring test dataset into: ./images${NC}"
tar xvfz $2 -C ./images/ > /dev/null 2>&1

echo
echo -e "${B}Converting PGM images to PNG images and removing PGM images${NC}"
find . -name '*.pgm' -type f  -exec sh -c 'pnmtopng "${0%}" > "${0%.*}.png"; rm -f "${0%}"' {} \;
