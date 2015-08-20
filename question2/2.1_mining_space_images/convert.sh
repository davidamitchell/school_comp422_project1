#!/bin/bash
pngtopam -plain images/hubble_min.png | sed 's/255/1/g' > images/hubble_min.pbm
