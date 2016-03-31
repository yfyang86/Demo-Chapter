#!/bin/sh
convert -units PixelsPerInch fonts.png -density 400 fonts.pbm
perl fonttrace.pl fonts.pbm | sh
mogrify -format pnm *.png
for i in `ls -1 *.pnm | sed -e 's/\..*$//'`; do potrace -s  $i.pnm; done
