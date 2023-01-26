#!/bin/sh
# build-everything
# Simple script that allows you to build everything in the repository.
EXCLUDE_PACKAGE="gcc"
EXCLUDE_PACKAGE1="kreainit"

[ "$(id -u)" != "0" ] && exit 1
[ -f "new.txt" ] && rm -f new.txt
for i in *
do
    if [ -d "$i" ] && [ "$i" != "$EXCLUDE_PACKAGE" ] && [ "$i" != "$EXCLUDE_PACKAGE1" ]
    then
        . "$i/run"
    fi
done
echo "The tarballs are now located in /etc/nyaa.tarballs"
echo "New packages that are compiled;"
echo "$(cat new.txt)"
