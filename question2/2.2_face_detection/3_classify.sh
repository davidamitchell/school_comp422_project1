#!/bin/bash
B='\033[0;34m\033[1m'
NC='\033[0m'

echo
echo -e "${B}Untaring feature dataset into: ./data${NC}"
rm -f data/*csv > /dev/null 2>&1
tar xvfz data/feature_files.tar.gz > /dev/null 2>&1

echo
echo -e "${B}Running classification${NC}"
bundle exec ruby ./classify.rb

echo
echo -e "${B}Cleaning up${NC}"
rm -f data/*csv > /dev/null 2>&1
