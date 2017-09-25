#! /bin/bash
date=$(date --date="1 day ago" +%Y-%m-%d)

#What to backup.
backup_output="/home/pi/motioneye/output"

#device to backup to
volume="/home/pi/motioneye/backup"

# Where to backup to.
dest="$volume"

# $backup_output/$date/create archive filename.
archive_file="$date.tgz"

cat $backup_output/$date/*.avi > $backup_output/$date/out_tmp.avi

wait

avconv -i $backup_output/$date/out_tmp.avi -c copy $backup_output/$date/output.avi

wait
mv $backup_output/$date/output.avi $backup_output/$date/output.save
 
rm $backup_output/$date/*.avi

mv $backup_output/$date/output.save $backup_output/$date/output.avi

tar cpfz $dest/$archive_file $backup_output/$date

tarSize=$( tar -czf - $dest/$archive_file | wc -c )

wait

if [ $tarSize -gt "0" ]
then
	rm -rf $backup_output/$date
fi

