<!-- ```bash

oc delete project edgetraining

cat <<EOF | oc apply  -f -
kind: List
metadata: {}
apiVersion: v1
items:
  - apiVersion: project.openshift.io/v1
    kind: Project
    metadata:
      name: edgetraining
      labels:
        kubernetes.io/metadata.name: edgetraining
        modelmesh-enabled: 'true'
        opendatahub.io/dashboard: 'true'
      annotations:
        openshift.io/display-name: "Edge Training"
        openshift.io/requester: admin
EOF

oc apply -n edgetraining -f ./bootstrap.project.yaml

# wait for the secrets to be created ...
echo -n 'Waiting for my-storage secret\n'
while ! oc -n edgetraining get secret aws-connection-my-storage 2>/dev/null ; do
  echo -n .
  sleep 5
done; echo


oc apply -n edgetraining -f ./pipelineserver.yaml
oc apply -n edgetraining -f ./modelserving.yaml

# upload the code to S3
oc delete -n edgetraining job upload-s3-data
oc apply -n edgetraining -f ./upload-s3-data.yaml

# add the task
oc apply -n edgetraining -f https://raw.githubusercontent.com/tektoncd/catalog/main/task/openshift-client/0.2/openshift-client.yaml

# rerun the pipeline
oc delete -n edgetraining pipelinerun training-pipeline
oc apply -n edgetraining -f ./train_pipepine_run.yaml

```



 -->
