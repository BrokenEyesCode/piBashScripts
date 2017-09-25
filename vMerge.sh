#!/bin/bash
videoDir="/home/pi/motioneye/output"
date=$(date +%Y-%m-%d)
filesList=""
for file in $(ls $videoDir/$date/*.avi|sort -n);do
    filesList="$filesList -cat $file"
done
echo $filesList >> $videoDir/$date/files.txt
