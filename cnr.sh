#!/bin/sh

my_sum_start=$( shasum $0 )
while [ true ] ; do
	my_sum_now=$( shasum $0 )
	if [ "${my_sum_start}" != "${my_sum_now}" ] ; then
		exec $0 $*
	fi

	a=$( sum $( ls | egrep "(Makefile|\.c$)" ) )
	if [ "$a" != "$b" ] ; then
		b="$a"
		clear
		make clean || continue
		make test
	fi
	sleep 1
done

