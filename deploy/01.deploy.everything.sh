
NS=${NS:-edgetraining}

oc cluster-info

# if oc cluster-info | grep -E -q 'dynamic\.opentlc\.com'
# then
#     printf "OK. Using RHPDS cluster. Continuing\n"
# else
#     printf "Nope. You are not connected to an RHPDS. That is dangerous. Exiting \n"
#     exit 1
# fi



## RHOAI
oc apply -f ./01-rhoai/operator.yaml

## insert step here that waits for CRDs to exist
while ! oc get crd | grep -qF datasciencecluster  2>/dev/null ; do
  echo -n .
  sleep 5
done; echo

oc apply -f ./01-rhoai/dsc.yaml

# Pipelines Operator
oc apply -f ./02-pipelines/operator.yaml
# wait for project
while ! oc get crd | grep -qF pipelines  2>/dev/null ; do
  echo -n .
  sleep 5
done; echo

# Project
oc apply -f ./03-project/project.yaml

# wait for project
while ! oc get project | grep -qF edgetraining  2>/dev/null ; do
  echo -n .
  sleep 5
done; echo

# Object Storage
oc -n ${NS} apply -f ./04-minio/minio.yaml

# wait for the secrets to be created ...
echo -n 'Waiting for my-storage secret\n'
while ! oc -n ${NS} get secret aws-connection-my-storage 2>/dev/null ; do
  echo -n .
  sleep 5
done; echo

echo -n 'Waiting for buckets to exist.'
while [ "$(oc -n ${NS} get pod -l job-name=create-minio-buckets -o jsonpath='{.items[0].status.phase}')" != "Succeeded" ] ; do
  echo -n .
  sleep 5
done
echo

# Model Serving
  # ensure model serving stuff exists here.
  # TODO
oc -n ${NS} apply -f ./05-serving/modelserving.yaml

# Pipeline Server
oc -n ${NS} apply -f ./06-pipelineserver/pipelineserver.yaml

# install new task
oc -n ${NS} apply -f ./07-pipelinerun/task.yaml

# Execute the pipeline run
oc -n ${NS} create -f ./07-pipelinerun/pipepinerun.yaml

# deploy the pinger

if oc -n edgetraining get deploy  | grep -qF pinger  2>/dev/null ; then
  ## delete it if it exists
  oc -n edgetraining delete -f ./08-test-inference/pinger.yaml
fi
oc -n edgetraining apply -f ./08-test-inference/pinger.yaml

# alternative way of doing the pipeline (experimental)
# oc -n ${NS} create -f ./07-pipelinerun/pipepine.yaml
