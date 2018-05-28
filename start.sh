#!/bin/sh
cd toolbox
if [ ! -f docker-compose.yml ]
then
  cp docker-compose.in.yml docker-compose.yml
fi
docker-compose down
docker-compose up --build -d
	
