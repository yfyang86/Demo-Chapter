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
    s=$(($(($u / 8)) + 1))
    s=$(($(($s * 8)) - $u))
    if [ $s -gt 0 ];then
	echo "=============="
	echo "Add $s Pages"
	echo "=============="
	echo "" | ps2pdf -sPAPERSIZE=letter - blank.pdf
	ss=1
	while [ $ss -le $s ];do
		pdftk A=$1 B=blank.pdf cat A1-end B1 output temp9375.pdf
		mv temp9375.pdf $1
		ss=$(($ss + 1))
	done
    fi
    u=$(($u + $s))
    starter=1
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
echo "\end{document}">>renumTemp.tex
pdflatex renumTemp.tex
rm renumTemp.tex blank.pdf
fi
