#!/bin/bash

cat ../source/mp3.rst ../source/cdrip.rst ../source/settings.rst > ./cactus.rst

rstconv -i cactus.rst -o cactus_tmp1.po

cat ./header.po cactus_tmp1.po > cactus_tmp.po


msgmerge cactus.pt_BR.po cactus_tmp.po -o cactus.pt_BR.po

rm cactus_tmp.po
rm cactus_tmp1.po

echo " cactus.pt_BR.po updated. now update/modify/correct the translations inside..."
