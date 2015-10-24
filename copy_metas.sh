#!/bin/bash

ssh -t -t root@rocket.chat <<-ENDSSH
	ssh -f -L 27019:localhost:27017 -N root@001-db.konecty.com -q
	mongoexport -h localhost:27019 -d rocketchat -c MetaObjects | mongoimport -d rocketchat -c MetaObjects --upsert
	pm2 restart kondata.rocketchat
	exit
ENDSSH
