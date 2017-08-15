#! /bin/bash
# Get hostname
hostname=`hostname` 2> /dev/null

# Get distro
distro=`python -c 'import platform ; print platform.linux_distribution()[0] + " " + platform.linux_distribution()[1]'` 2> /dev/null

# Get uptime
if [ -f "/proc/uptime" ]; then
uptime=`cat /proc/uptime`
uptime=${uptime%%.*}
seconds=$(( uptime%60 ))
minutes=$(( uptime/60%60 ))
hours=$(( uptime/60/60%24 ))
days=$(( uptime/60/60/24 ))
uptime="$days days, $hours hours, $minutes minutes, $seconds seconds"
else
uptime=""
fi

#HDD Total
#hddTotal=$(df -h | grep "/dev/sda5" | cut -c44-46)
hddTotal=0
#HDD Used
#hddUsed=$(df -h | grep "/dev/sda5" | cut -c51-52)
hddUsed=0
#HDD Free
#hddFree=$(df -h | grep "/dev/sda5" | cut -c57-58)
hddFree=0
#SD Total
sdTotal=$(df -h | grep "/dev/root" | cut -c18-19)
#SD Used
sdUsed=$(df -h | grep "/dev/root" | cut -c29-31)
#SD Free
sdFree=$(df -h | grep "/dev/root" | cut -c22-25)
#cpu temp
cpuTemp=$(/opt/vc/bin/vcgencmd measure_temp | cut -c6-9)
#Cpu Load 1
cpuload1=$(cat /proc/loadavg | cut -c1-4)
#Cpu load 2
cpuload2=$(cat /proc/loadavg | cut -c6-9)
#Cpu Load 3
cpuload3=$(cat /proc/loadavg | cut -c11-14)
#Memory Total
memTotal=$(free -mt |grep Total | cut -c 16-18)
#Memory Free
memFree=$(free -mt |grep Total | cut -c 38-40)
#Memory Used
memUsed=$(free -mt |grep Total | cut -c 27-29)
#Date Date
datadate=$(date +"%d/%m/%Y %H:%M")
#network
#networkTX=$(procinfo | grep "wlan0" | cut -c16-20)
#networkRX=$(procinfo | grep "wlan0" | cut -c33-37)
networkTX=0;
networkRX=0;

#datafile
#dataFile='/media/webdav/public_html/data/sysInfo.json';
dataFile='/home/pi/sysInfo.json';

# remove old log
currData=$(printf '{"datadate":"%s","hostname":"%s","distro":"%s","uptime":"%s","hdtotal":"%s","hdused":"%s","hdfree":"%s","sdtotal":"%s","sdused":"%s","sdfree":"%s","cputemp":"%s","cpuload1":"%s","cpuload2":"%s","cpuload3":"%s","memtotal":"%s","memused":"%s","memfree":"%s","networkTX":"%s","networkRX":"%s"}' "$datadate" "$hostname" "$distro" "$uptime" "$hddTotal" "$hddUsed" "$hddFree" "$sdTotal" "$sdUsed" "$sdFree" "$cpuTemp" "$cpuload1" "$cpuload2" "$cpuload3" "$memTotal" "$memUsed" "$memFree" "$networkTX" "$networkRX")

l=168
c=0
while read dataLine
do
        let c++
        if [[ "$c" -lt  "$l" ]] ; then
                 dataLn="$dataLn $dataLine \n"
        fi
        if [[ "$c" -eq  "$l" ]] ; then
                dataLn="$dataLn "${dataLine%?}
        fi

done <  $dataFile

# get data between []
dataSeg=$(echo -e $dataLn | cut -d "[" -f2 | cut -d "]" -f1 )

if [ $c -gt  0 ]
	then
        dataSeg=$(echo -e ",\n$dataSeg")
fi

# put result in new variable.
newData=$(printf '{"data":[%s %s]}' "$currData" "$dataSeg")

# output to file
echo -e "$newData" > $dataFile
