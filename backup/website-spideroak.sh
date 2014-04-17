#!/bin/bash
# cronjob could look like:
# 0 0 * * * /usr/local/bin/wordpress-spideroak.sh wp blog >> /home/ubuntu/ubuntucron.log 2>&1
# 0 0 * * * /usr/local/bin/wordpress-spideroak.sh w2 blo2 >> /home/ubuntu/ubuntucron.log 2>&1
# 0 0 * * * /usr/local/bin/foobar-spideroak.sh foo bar >> /home/ubuntu/ubuntucron.log 2>&1
DBNAME=$1
WEBFOLDER=/var/www/$2  # should modify, assuming dir /var/www

SERVER=ec2tk # should modify with a uid
# BCKP_DIR=$(mktemp -d)
BCKP_DIR="/home/ubuntu/SpiderOak Hive/backup/${SERVER}/${DBNAME}"
mkdir -p "${BCKP_DIR}"
TIMESTAMP=`date +%F`

BCKP_FILE=${TIMESTAMP}-${DBNAME}-db.sql.bz2.gpg
BCKP_WP=${TIMESTAMP}-${WEBFOLDER}-wp.tar.bz2.gpg

BZ="/bin/bzip2 -9"
PW=secret_password
DUMP="/usr/bin/mysqldump -e -u root -p${PW} $DBNAME"
TAR="/bin/tar c"
GPG='/usr/bin/gpg --yes --sign -e -u "ec2tk" -r "dvdyzag@opmbx.org" -'

$DUMP | $BZ | $GPG > "${BCKP_DIR}/${BCKP_FILE}"
$TAR ${WEBFOLDER} | $BZ | $GPG > "${BCKP_DIR}/${BCKP_WP}"
SO="/usr/bin/SpiderOak --batchmode"