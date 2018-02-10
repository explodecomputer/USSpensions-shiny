#!/bin/bash

# to update version:
# 1. git tag <new version number>
# 2. git push origin <new version number>
# 3. ./update_version.sh
# 4. git commit -a -m "updated version"
# 5. git push


version=`git tag | sed 's/\b\([0-9]\)\b/0\1/g' | sort | sed 's/\b0\([0-9]\)/\1/g' | tail -n 1`

if [[ "$1" -eq "1" ]]
then
	echo "1"
	echo "old version: ${version}"
	x=`echo ${version} | cut -d "." -f 1`
	x=$(( $x + 1 ))
	new_version=`echo "${x}.0.0"`
	echo "new version: ${new_version}"
elif [[ "$1" -eq "2" ]]
then
	echo "2"
	echo "old version: ${version}"
	x1=`echo ${version} | cut -d "." -f 1`
	x2=`echo ${version} | cut -d "." -f 2`
	x2=$(( $x2 + 1 ))
	new_version=`echo "${x1}.${x2}.0"`
	echo "new version: ${new_version}"
elif [[ "$1" -eq "3" ]]
then
	echo "3"
	echo "old version: ${version}"
	x1=`echo ${version} | cut -d "." -f 1`
	x2=`echo ${version} | cut -d "." -f 2`
	x3=`echo ${version} | cut -d "." -f 3`
	x3=$(( $x3 + 1 ))
	new_version=`echo "${x1}.${x2}.${x3}"`
	echo "new version: ${new_version}"
else
	echo "specify update type"
	exit
fi

git tag ${new_version}
git push origin ${new_version}


commit=`git show ${new_version} | grep commit | cut -d " " -f 2 | cut -c 1-6`

echo "${new_version} ${commit}" > version.txt

git commit -a -m "updated version"
git push
