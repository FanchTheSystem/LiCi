#!/usr/bin/env bash
set -ex

source Scripts/pipeline.usefull.bash.function

run_pipeline_sh Jenkins/docker.clean.pipeline

export Version=3.3.1
export Hostname=etcd.host
run_pipeline_sh Jenkins/etcd.pipeline

#export Hostname=postgres.host
#export Version=9.4
#export Password=postgres24
#run_pipeline_sh Jenkins/postgres.pipeline

export Version=0.15.0
export Hostname=confd.host
run_pipeline_sh Jenkins/confd.pipeline

export Version=6.1.1
export Hostname=elastic.host
run_pipeline_sh Jenkins/elastic.pipeline

export Version=firefox:3.7.0-arsenic
export Hostname=selenium.host
run_pipeline_sh Jenkins/selenium.pipeline
