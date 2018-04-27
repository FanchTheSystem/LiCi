#!/usr/bin/env bash
set -e

for i in $(docker container ls -q); do docker container stop $i; docker container rm -v $i; done
docker network prune -f
docker system prune -a -f
docker volume prune -f
docker network create ci.network
docker images
docker container ls
docker network ls --no-trunc
docker network inspect ci.network
docker container stop etcd.host || echo ok
docker container rm etcd.host || echo ok
docker build --build-arg ETCDVER=3.3.1 --build-arg UID=`id -u` --build-arg GID=100 -t etcd-img-3.3.1 -f Docker/etcd.dockerfile .
docker run -dt -p 2379:2379 --network=ci.network --name etcd.host etcd-img-3.3.1
docker exec etcd.host etcd --version
docker container stop confd.host || echo ok
docker container rm confd.host || echo ok
docker build --build-arg CONFDVER=0.15.0 --build-arg UID=`id -u` --build-arg GID=100 -t confd-img-0.15.0 -f Docker/confd.dockerfile .
docker run -dt --network=ci.network --volume $HOME/public_html:/home/jenkins/public_html --name confd.host confd-img-0.15.0
docker exec confd.host confd --version
