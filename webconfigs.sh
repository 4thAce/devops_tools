#/bin/bash
# Script to download the web front end server configurations
# Run this with one argument, the name of a file containing the addresses of the front end servers (1 per line)


OUTDIR=/srv/log
ENVIRONMENT=test2
ERRFILE=webconfig.2.txt
OUTFILE=webconfig.1.txt
#. /srv/etc/awscred
rm $OUTDIR/$ERRFILE || echo "Create $OUTDIR/$ERRFILE" > $OUTDIR/$ERRFILE
rm $OUTDIR/$OUTFILE || echo "Create $OUTDIR/$OUTFILE" > $OUTDIR/$OUTFILE
# We could get the list of front end servers here

while IFS='' read -r line || [[ -n "$line" ]]; do
    echo $line >> $OUTDIR/$OUTFILE
    echo $line >> $OUTDIR/$ERRFILE
    mkdir $OUTDIR/$line 2>/dev/null
    scp $line:/srv/etc/* $OUTDIR/$line/ >> $OUTDIR/$OUTFILE 2>> $OUTDIR/$ERRFILE 
    mkdir -p $OUTDIR/$line/current/config 2>/dev/null
    scp $line:/srv/app/4dstudio/current/config/* $OUTDIR/$line/current/config  >> $OUTDIR/$OUTFILE 2>> $OUTDIR/$ERRFILE
    mkdir -p $OUTDIR/$line/nginx/conf.d/ 2>/dev/null
    scp $line:/srv/app/nginx-1.4.7/conf/* $OUTDIR/$line/nginx/>> $OUTDIR/$OUTFILE 2>> $OUTDIR/$ERRFILE
    #  Copy the files to s3 (this works directly, unlike the case on beta4ds)
    tar czf $OUTDIR/$line.tgz $OUTDIR/$line/ >> $OUTDIR/$OUTFILE 2>> $OUTDIR/$ERRFILE
    aws s3 cp $OUTDIR/$line.tgz s3://4dconfig/$ENVIRONMENT-$line-`date +%F`.tgz >> $OUTDIR/$OUTFILE 2>> $OUTDIR/$ERRFILE
done < "$1"
