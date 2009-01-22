#!/bin/bash

cat ../source/mainform.rst ../source/cdrip.rst ../source/settings.rst > ./cactus.rst

rstconv -i cactus.rst -o cactus_tmp1.po

cat ./header.po cactus_tmp1.po > cactus_tmp.po


msgmerge cactus.sv.po cactus_tmp.po -o cactus.sv.po

rm cactus_tmp.po
rm cactus_tmp1.po

echo " cactus.sv.po updated. now update/modify/correct the translations inside..."
