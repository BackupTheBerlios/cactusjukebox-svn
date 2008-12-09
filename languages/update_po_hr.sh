#!/bin/bash

cat ../source/mainform.rst ../source/cdrip.rst ../source/settings.rst > ./cactus.rst

rstconv -i cactus.rst -o cactus_tmp1.po

cat ./header.po cactus_tmp1.po > cactus_tmp.po


msgmerge cactus.hu.po cactus_tmp.po -o cactus.hr.po

rm cactus_tmp.po
rm cactus_tmp1.po

echo " cactus.hr.po updated. now update/modify/correct the translations inside..."
