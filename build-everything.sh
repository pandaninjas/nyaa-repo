#!/bin/sh
# build-everything
# Simple script that allows you to build everything in the repository.
EXCLUDE_PACKAGE="gcc"
EXCLUDE_PACKAGE1="kreainit"

kpkg update

cat >/etc/kpkg.conf <<EOL
[Options]
cc=gcc
[Repositories]
RepoDirs=$(realpath .)
RepoLinks="https://github.com/kreatolinux/nyaa-repo.git https://github.com/kreatolinux/nyaa-repo-bin.git"
[Upgrade]
buildByDefault=yes
EOL

[ "$(id -u)" != "0" ] && exit 1
[ -f "new.txt" ] && rm -f new.txt
[ -f "failed.txt" ] && rm -f failed.txt
for i in *
do
    if [ -d "$i" ] && [ "$i" != "$EXCLUDE_PACKAGE" ] && [ "$i" != "$EXCLUDE_PACKAGE1" ]
    then
        if [ ! -f "/etc/nyaa.tarballs/nyaa-tarball-$i-$VERSION.tar.gz" ]
        then
            echo "now building $i"
            kpkg build -y $i > /dev/null
            if [ $? -eq 0 ]
            then
                echo "$i" >> new.txt
            else
                echo "$i" >> failed.txt
            fi
            [ -f "/tmp/kpkg.lock" ] && rm -f /tmp/kpkg.lock
        fi
    fi
done
echo "The tarballs are now located in /etc/nyaa.tarballs"
echo "New packages that are compiled;"
cat new.txt
echo "These packages failed to compile"
cat failed.txt
