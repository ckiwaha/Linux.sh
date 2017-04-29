####parse the file name to get month year output to log
#Create log references
#Check for Files and file list first, pulling out year month and filename
#use file list, ftp into jasper, create directory and put files
#remove the files when complete and rename old output lists, also remove 5 day old output lists
####Creates log file entries
LOG_FILE=/home/edi/bin/log_file.txt
#exec > >(tee -a ${LOG_FILE} )
#exec 2> >(tee -a ${LOG_FILE} >&2)

###Gets all files ending in txt which has list of files: to copy
dest=/EDI/tmsarchive

###Create date format for ftp dir
d=$(date +%Y%m%d)

####Check to see if there are any *.txt file to process
if ls "$dest"/*.txt 1> /dev/null 2>&1; then

for f in "$dest"/*.txt
do
 ####Reads ARCHIVE_OUTBOUND  file contents which is list of files to process
 while read l;
 do
  #echo $l
  filename=${l##*/}
  ###This parses out the filename from the full file path
  #echo $filename
  ####This parses out the year from file path
  EOP=${l:57:4}
  #echo $EOP
  dest="$dest/"
  dest=$dest$filename
  cp -n "$l" "$dest"  
  #echo "$l" "$dest"
  dest=/EDI/tmsarchive
 done <$f
 #echo $f
done
else
 echo "No *.txt files to process"
fi

#Check to see if *.dat files exits to FTP
if ls "$dest"/*.dat 1> /dev/null 2>&1; then

HOST=jasper-lc.allenlund.com
USER=admin
PASSWORD=admin
MAKEDIR=$d
(
ftp -inv $HOST <<EOF
user $USER $PASSWORD
pwd
lcd /EDI/tmsarchive
mkdir $MAKEDIR
ls
cd $MAKEDIR
mput *.dat
bye
EOF
) > $LOG_FILE

dest=/EDI/tmsarchive
###Delete all the dat files
find "$dest"/*.dat -exec rm {} \;

#for f in "$dest"/*.dat
#do
# rm "$f" 
#done

else
 echo "no files to ftp"
fi

if ls "$dest"/*.txt 1> /dev/null 2>&1; then
for f in "$dest"/*.txt
do
 mv "$f" "$f".bak
done
else
 echo "no files rename to *.bak"
fi

if ls "$dest"/*.bak 1> /dev/null 2>&1; then
##Delete bak files older than 5 days
find "$dest"/*.bak -mtime +5 -exec rm {} \;
fi

exit
