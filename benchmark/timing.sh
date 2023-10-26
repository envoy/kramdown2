#!/bin/bash

source ~/.bashrc

for VERSION in `rvm list strings | sort`; do
	rvm $VERSION
	echo $(ruby -v)
	ruby -Ilib bin/kramdown2 < benchmark/mdsyntax.text 2>/dev/null >/dev/null
	time ruby -Ilib bin/kramdown2 < benchmark/mdsyntax.text 2>/dev/null >/dev/null
done
