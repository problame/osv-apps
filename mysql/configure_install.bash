#!/bin/bash

set -e

if [ "$#" -ne "2" ]; then
	exit 1
fi

BASEDIR="$1"
ROOTDIR="$2"

cd "$ROOTDIR"
cp "$BASEDIR/my.cnf" etc/
cd usr

./scripts/mysql_install_db --force --basedir=./ --ldata=data
cat <<EOF | eval './bin/mysqld  --bootstrap --skip-grant-tables --basedir=./ --datadir=data --max_allowed_packet=8M --net_buffer_length=16K'
use mysql;
set table_type=myisam;
insert into user values('192.168.1.1', 'admin', password('osv'), 'Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','','','','',0,0,0);
EOF


