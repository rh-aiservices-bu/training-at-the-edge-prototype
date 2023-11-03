


```bash

oc -n redhat-ods-operator delete OperatorGroup --all

cat <<EOF | oc apply  -f -
kind: List
metadata: {}
apiVersion: v1
items:
  -   apiVersion: project.openshift.io/v1
      kind: Project
      metadata:
          name: redhat-ods-operator
  -   apiVersion: operators.coreos.com/v1
      kind: OperatorGroup
      metadata:
          name: redhat-ods-operator
          namespace: redhat-ods-operator
  -   apiVersion: operators.coreos.com/v1alpha1
      kind: Subscription
      metadata:
          name: rhods-operator
          namespace: redhat-ods-operator
      spec:
          channel: alpha
          installPlanApproval: Automatic
          name: rhods-operator
          source: redhat-operators
          sourceNamespace: openshift-marketplace
          #startingCSV: rhods-operator.2.2.0
EOF

# oc patch installplan \
#     $(oc get installplans -n redhat-ods-operator | grep -v NAME | awk '{print $1}') \
#     -n redhat-ods-operator \
#     --type='json' \
#     -p '[{"op": "replace", "path": "/spec/approved", "value": true}]'

```

```bash
cat <<EOF | oc apply  -f -
apiVersion: datasciencecluster.opendatahub.io/v1
kind: DataScienceCluster
metadata:
  name: default
  namespace: redhat-ods-operator
  labels:
    app.kubernetes.io/name: datasciencecluster
    app.kubernetes.io/instance: default
    app.kubernetes.io/part-of: rhods-operator
    app.kubernetes.io/managed-by: kustomize
    app.kubernetes.io/created-by: rhods-operator
spec:
  components:
    codeflare:
      managementState: Removed
    dashboard:
      managementState: Managed
    datasciencepipelines:
      managementState: Managed
    kserve:
      managementState: Removed
    modelmeshserving:
      managementState: Managed
    ray:
      managementState: Removed
    workbenches:
      managementState: Managed
EOF
```
