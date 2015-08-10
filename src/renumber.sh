#!/bin/sh

if [ ! -f $1 ]; then
    echo "File not found!"
else
    echo "\\documentclass[letterpaper]{article}">renumTemp.tex
    echo "\\usepackage{pdfpages}">>renumTemp.tex
    echo "\\usepackage[pdfpagelabels]{hyperref}">>renumTemp.tex
    echo "\n">>renumTemp.tex
    echo "\\\begin{document}">>renumTemp.tex
    u=`pdfinfo $1 | grep "Pages" | awk '{print $2}'`
    starter=1
    if [ $u -gt 4 ]; then
	while [ $starter -lt $u ]; do
		s1=$(($starter+2))
		s2=$(($starter+4))
		s3=$(($starter+6))
		u1=$(($starter+3))
		u2=$(($starter+1))
		u3=$(($starter+7))
		u4=$(($starter+5))
		echo "\\includepdf[pages={$starter,$s1,$s2,$s3}]{$1}">>renumTemp.tex
		echo "\\includepdf[pages={$u1,$u2,$u3,$u4}]{$1}">>renumTemp.tex
		starter=$(($starter+8))
	done
    fi
#remain
while [ $starter -le $u ]; do
	echo "\includepdf[pages=$starter]{$1}">>renumTemp.tex
	starter=$(($starter+1))
done;
echo "\end{document}">>renumTemp.tex
pdflatex renumTemp.tex
rm renumTemp.tex
fi
