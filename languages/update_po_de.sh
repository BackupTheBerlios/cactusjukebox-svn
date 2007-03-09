#!/bin/bash

cat ../mp3.rst ../cdrip.rst ../settings.rst > ./cactus.rst

rstconv -i cactus.rst -o cactus_tmp1.po

cat ./header.po cactus_tmp1.po > cactus_tmp.po


msgmerge cactus.de.po cactus_tmp.po -o cactus.de.po

rm cactus_tmp.po
rm cactus_tmp1.po

echo " cactus.de.po updated. now update/modify/correct the translations inside..."
