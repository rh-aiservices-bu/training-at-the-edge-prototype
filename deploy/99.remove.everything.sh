NS=${NS:-edgetraining}


# oc -n openshift-operators delete Subscription openshift-pipelines-operator-rh

# oc -n redhat-ods-operators delete delete -f

# oc delete -f ./01-rhoai/operator.yaml
# oc delete -f ./01-rhoai/dsc.yaml


## RHOAI
oc delete -f ./01-rhoai/operator.yaml
oc delete -f ./01-rhoai/dsc.yaml

# Pipelines Operator
oc delete -f ./02-pipelines/operator.yaml
# not sure why this is needed:
oc -n openshift-operators delete ClusterServiceVersion openshift-pipelines-operator-rh.v1.12.1
oc -n openshift-operators delete OperatorGroup global-operators

# remove project
oc delete project edgetraining
