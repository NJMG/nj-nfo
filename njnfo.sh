#!/bin/bash
# NFO viewer
# 22/12/2015
#path & nom du script & mod debug( 0=false ; 1=true ):
SCRIPT=$0
SCRIPTPATH=$(dirname $SCRIPT)
SCRIPTNAME=$(basename $SCRIPT)
Sdebug=0
SbeROOT=0
#####################################
#Script Test if in terminal ( verbose OK )
#fd=0 ; [[ -t "$fd"  ]] && { SinTerm=1 ;}
[[ -t 0 ]] && { SinTerm=1 ;}

((SinTerm)) || exit 0

#####################################
locale_LANG=$LANG
M_IFS=$IFS
LANG="C.UTF-8"
linesterm=$(tput lines)
columnsterm=$(tput cols)
#####################################

[[ $1 ]] || { echo "<!> usage : $SCRIPTNAME filename.nfo" ; exit 1 ;}

[[ -f $1 ]] && { vnfo=$( iconv -c -f 'CP437' -t 'UTF-8'//TRANSLIT "$1" | sed 's/\r$//' ) ;} || { echo "<!> usage : $SCRIPTNAME filename.nfo" ; exit 1 ;}

vcp1252=$(iconv -c -f "CP1252" -t "UTF-8"//TRANSLIT "$1" | sed -r 's/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g' )

njwcL=$( wc -L <<< $vcp1252 )

IFS=:	# placer IFS a 0

maxLenght=0
while read -r line ;  do  ### options -r obligatoire
		lline=${#line}
		((lline > maxLenght)) && ((maxLenght=$lline))
done <<< "$vcp1252" 

pad=$((($columnsterm-${maxLenght})/2))

while read -r line ;  do  
		((maxLenght < columnsterm)) && { printf '%*s' $pad ;}
		echo -e "\e[38;5;15m${line}\e[00m"
done <<< "$vnfo" 

echo
((Sdebug)) && echo " Columns: $columnsterm"
((Sdebug)) && echo " maxLenght : $maxLenght"
((Sdebug)) && echo " wc -L : $njwcL"
((Sdebug)) && echo " pad: $pad"
((Sdebug)) && echo " Locale: $LANG"
((Sdebug)) && echo

LANG=$locale_LANG
IFS=$M_IFS

exit 0
