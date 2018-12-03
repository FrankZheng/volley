#!/bin/bash


if [ $# = 0 ] 
	then
	echo 'should pass tha aar dir'
	exit 1
fi

aar_dir=$1
jarjar=$(pwd)/jarjar-1.4.jar
rules_txt=$(pwd)/rules.txt
domain=xqlabserv

pushd $aar_dir
unzip volley-release.aar
# manifest
sed -i '' "s/com.android.volley/com.${domain}.volley/g" AndroidManifest.xml
# proguard
sed -i '' "s/com.android.volley/com.${domain}.volley/g" proguard.txt
# annotations.zip
unzip annotations.zip
mv com/android com/$domain
sed -i '' "s/com.android.volley/com.${domain}.volley/g" com/$domain/volley/annotations.xml
rm -f annotations.zip && zip -r annotations.zip com && rm -rf com

# jar
java -jar $jarjar process $rules_txt classes.jar classes.jar

# zip
rm -rf volley-release.aar && zip volley-release.aar *

# cleanup
ls | grep -v volley-release.aar | xargs rm 
popd