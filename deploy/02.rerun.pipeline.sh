#!/bin/bash

NS=${NS:-edgetraining}

if oc cluster-info | grep -E -q 'dynamic\.opentlc\.com'
then
    printf "OK. Using RHPDS cluster. Continuing\n"
else
    printf "Nope. You are not connected to an RHPDS. That is dangerous. Exiting \n"
    exit 1
fi

# Execute the pipeline run
# oc delete -n edgetraining pipelinerun training-pipeline
oc -n ${NS} create -f ./07-pipelinerun/pipepinerun.yaml
