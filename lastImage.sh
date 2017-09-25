#!/bin/bash

date=$(date +%Y-%m-%d)

input="/home/pi/motioneye/output/$date"

output="/home/pi/motioneye/output"

f=$(ls "$input"/*.jpg -t | head -n1)

ln -s -f $f "$output"/lastsnap.jpg
