#!/bin/bash

cat source/cactus_const.inc | grep ' *CACTUS_VERSION *=.*;' | sed -e 's/const....[A-Z_ =;]*.//g' -e 's/.;//g' -e's/ //g'
