


```bash
oc -n openshift-operators delete Subscription openshift-pipelines-operator-rh
oc -n openshift-operators delete OperatorGroup global-operators
oc -n openshift-operators delete ClusterServiceVersion openshift-pipelines-operator-rh.v1.12.1

cat <<EOF | oc apply  -f -
kind: List
metadata: {}
apiVersion: v1
items:
  -   apiVersion: operators.coreos.com/v1
      kind: OperatorGroup
      metadata:
        name: global-operators
        namespace: openshift-operators
      spec:
        upgradeStrategy: Default
  -   apiVersion: operators.coreos.com/v1alpha1
      kind: Subscription
      metadata:
        labels:
          operators.coreos.com/openshift-pipelines-operator-rh.openshift-operators: ""
        name: openshift-pipelines-operator-rh
        namespace: openshift-operators
      spec:
        channel: latest
        installPlanApproval: Automatic
        name: openshift-pipelines-operator-rh
        source: redhat-operators
        sourceNamespace: openshift-marketplace
        #startingCSV: openshift-pipelines-operator-rh.v1.12.1
EOF

```

