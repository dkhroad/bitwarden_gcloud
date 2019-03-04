source docker.env 

if [ "$1" == "-r" ]; then 
  shift
  docker run --rm  \
    -e GS_AUTH2_REFRESH_TOKEN=$GS_AUTH2_REFRESH_TOKEN \
    -e PROJECT_ID=$PROJECT_ID \
    -v $HOST_BW_DATA_DIR:/data  \
    dkhroad/bw_backup /restore.sh "$@"
elif [ "$1" == "-gcs" ]; then
  docker run -d  --name backup_gcs --restart=unless-stopped  \
    -e GS_AUTH2_REFRESH_TOKEN=$GS_AUTH2_REFRESH_TOKEN \
    -e PROJECT_ID=$PROJECT_ID \
    --volumes-from backup  \
    dkhroad/bw_backup 
else 
  docker run -d  --name backup --restart=unless-stopped  \
    -e CRON_TIME="0 * * * *" \
    -v $HOST_BW_DATA_DIR:/data  \
    bruceforce/bw_backup 
fi
