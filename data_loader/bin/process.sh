#!/bin/bash

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 [config_dir] [process_name] [env_name]";
    exit 1;
fi

export PROCESS_OPTION=process.name=$2

java -cp ../dataloader-42.0.0-uber.jar -Denv.name=$3 -Dsalesforce.config.dir=$1 com.salesforce.dataloader.process.ProcessRunner $PROCESS_OPTION

