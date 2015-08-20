#!/bin/bash
B='\033[0;34m\033[1m'
NC='\033[0m'

if [ ! -d data ]; then
  mkdir data
fi

echo
echo -e "${B}Extracting features from training data into:${NC}"
echo "  - data/face.csv"
echo "  - data/non-face.csv"
echo "  - data/testdata_face.csv"
echo "  - data/testdata_non-face.csv"
bundle exec ruby ./select_features.rb

echo
echo -e "${B}Taring feature files into:${NC}"
echo " - data/feature_files.tar.gz"
tar -cvzf data/feature_files.tar.gz data/*csv > /dev/null 2>&1

echo
echo -e "${B}Cleaning up${NC}"
rm -f data/*csv  > /dev/null 2>&1

echo
