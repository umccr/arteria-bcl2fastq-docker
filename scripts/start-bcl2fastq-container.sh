#!/bin/bash
# This script will start the bcl2fastq container using the configuration below.

runfolder_base="/opt/monitored-folder"
output_base="/opt/bcl2fastq_output"
log_base="/opt/bcl2fastq_output"
port=9999
tag="prod"
timestamp="$(date +"%Y%m%d%H%M")"

tmpfile=$(mktemp /tmp/app.config.XXXXX)

# create a service config file to overwrite the default
cat > $tmpfile <<- EOF
---

bcl2fastq:
  versions:
    2.20.0.422:
      binary: bcl2fastq
      class_creation_function:  _get_bcl2fastq2x_runner

machine_type:
  NovaSeq:
    bcl2fastq_version: 2.20.0.422
  HiSeq X:
    bcl2fastq_version: 2.20.0.422


runfolder_path: $runfolder_base
default_output_path: $output_base
bcl2fastq_logs_path: $log_base

# Only folders and child folder of the directories listed here will be valid as
# output directories.
allowed_output_folders:
    - $output_base
EOF


# run the container with the custom configuration
docker run --rm -d --name=bcl2fastq-service-$tag-$timestamp -p $port:80 \
        -v $runfolder_base:$runfolder_base:ro \
        -v $output_base:$output_base \
        -v $log_base:$log_base \
        -v $tmpfile:/opt/bcl2fastq-service/config/app.config \
        umccr/arteria-bcl2fastq-docker:latest

rm $tmpfile
# Test the service with:
# curl localhost:9999/api | python -m json.tool
