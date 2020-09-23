#!/bin/bash

# chown cache folder to ubuntu

docker run --rm --user $UID --hostname `hostname` \
  -v /media/storage/duplicity/cache:/home/duplicity/.cache/duplicity \
  -v /media/storage/duplicity/gnupg:/home/duplicity/.gnupg \
  -v /media/storage/duplicity/logs:/var/log/duplicity \
  -v /media/storage/mentortek:/data \
  -e PASSPHRASE="$PASSWORD" \
  -e AWS_ACCESS_KEY_ID="$AWS_KEY_ID" \
  -e GPG_KEY="$GPG_KEY" \
  -e AWS_SECRET_ACCESS_KEY="$AWS_ACCESS_KEY" \
  -e TMPDIR="/home/duplicity/.cache/duplicity" \
  -e S3_USE_SIGV4="True" \
  duplicitydnimon:1.0 duplicity \
	--exclude /data/redmine/db \
	--exclude /data/mattermost/db \
	--exclude /data/gitea/db \
	--exclude /data/gitea/db-o \
	--exclude /data/gitea/app/ssh \
	--exclude /data/keycloak/db \
	--full-if-older-than=6M \
	--allow-source-mismatch \
	--s3-use-new-style \
	--s3-region-name us-east-1 \
	--s3-use-ia \
	--s3-endpoint-url "https://s3.us-east-1.amazonaws.com" \
	--encrypt-sign-key="$GPG_KEY" \
	--sign-key="$GPG_KEY" \
	--log-file /var/log/duplicity/duplicity.log \
	--archive-dir /home/duplicity/.cache/duplicity \
	 /data/ \
	boto3+s3://mentortek-backups-duplicity/backups
