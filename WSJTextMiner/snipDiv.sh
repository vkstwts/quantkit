#! /bin/bash
# Copyright (c) <2010> <Nick Torenvliet>
#
# Permission is hereby granted, free of charge, to any person
# obtaining a copy of this software and associated documentation
# files (the "Software"), to deal in the Software without
# restriction, including without limitation the rights to use,
# copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following
# conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
# OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
# WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.


printhelp () {
echo "snip is a simple bash html cutter that works by extracting a specific element 
from an html file and feeding it to html2text. It presupposes wellformed html
and that you know the kind of element you want and it's id.

Syntax:
snip <element  type>#<element id> <file to parsed>

Example:
snipDiv div#bodyContent /tmp/index.html
"
exit
}

quitter () {
echo "Element id not found. Quitting."; exit
}

[ "$1" = "-h" -o "$1" = "--help" -o "$1" = "" ] && printhelp

elementtype="$(echo $1 | cut -d '#' -f 1)"
id="$(echo $1 | cut -d '#' -f 2)"
htmlfile="$2"
thebegin=$(grep -nioE "id=\"$id\"" $htmlfile | cut -d ':' -f 1)
# echo $thebegin
[ -n "$thebegin" ] || quitter

sed -n ${thebegin}p "$htmlfile" | sed -re "s/^.*id=\"$id\"/<$elementtype id=\"$id\"/g" > /tmp/snipfile
sed -n $(($thebegin+1)),\$p "$htmlfile"  >> /tmp/snipfile

i=0
element=0
cat /tmp/snipfile | while read line; do
	let i++
	if [[ "$line" =~ "$elementtype" ]]; then
		elementbegincount="$(echo $line | grep -io "<$elementtype" | grep -c .)"
		elementendcount="$(echo $line | grep -io "</$elementtype" | grep -c .)"
		element=$(($element+$elementbegincount-$elementendcount))
		if [ "$element" -le 0 ]; then
			sed -n 1,${i}p /tmp/snipfile | html2text
			exit
		fi
	fi
done
