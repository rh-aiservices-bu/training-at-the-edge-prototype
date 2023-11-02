

```bash
#Create Minio and secrets

oc apply -n edgetraining -f https://raw.githubusercontent.com/rh-aiservices-bu/training-at-the-edge-prototype/main/deploy-rhoai/setup-minio.yaml


```


```bash

# oc delete project edgetraining



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

cat <<EOF | oc apply  -f -
kind: List
metadata: {}
apiVersion: v1
items:
  - apiVersion: serving.kserve.io/v1alpha1
    kind: ServingRuntime
    metadata:
      annotations:
        enable-auth: "false"
        enable-route: "true"
        opendatahub.io/disable-gpu: "true"
        opendatahub.io/template-display-name: OpenVINO Model Server
        opendatahub.io/template-name: ovms
        openshift.io/display-name: OVMS Server 01
      labels:
        name: ovms-server-01
        opendatahub.io/dashboard: "true"
      name: ovms-server-01
      namespace: edgetraining
    spec:
      builtInAdapter:
        memBufferBytes: 134217728
        modelLoadingTimeoutMillis: 90000
        runtimeManagementPort: 8888
        serverType: ovms
      containers:
      - args:
        - --port=8001
        - --rest_port=8888
        - --config_path=/models/model_config_list.json
        - --file_system_poll_wait_seconds=0
        - --grpc_bind_address=127.0.0.1
        - --rest_bind_address=127.0.0.1
        image: quay.io/opendatahub/openvino_model_server@sha256:20dbfbaf53d1afbd47c612d953984238cb0e207972ed544a5ea662c2404f276d
        name: ovms
        resources:
          limits:
            cpu: "2"
            memory: 8Gi
          requests:
            cpu: "1"
            memory: 4Gi
        volumeMounts:
        - mountPath: /dev/shm
          name: shm
      grpcDataEndpoint: port:8001
      grpcEndpoint: port:8085
      multiModel: true
      protocolVersions:
      - grpc-v1
      replicas: 1
      supportedModelFormats:
      - autoSelect: true
        name: openvino_ir
        version: opset1
      - autoSelect: true
        name: onnx
        version: "1"
      - autoSelect: true
        name: tensorflow
        version: "2"
      volumes:
      - emptyDir:
          medium: Memory
          sizeLimit: 2Gi
        name: shm

  - apiVersion: serving.kserve.io/v1beta1
    kind: InferenceService
    metadata:
      annotations:
        openshift.io/display-name: Fraud v01
        serving.kserve.io/deploymentMode: ModelMesh
      labels:
        name: fraud-v01
        opendatahub.io/dashboard: "true"
      name: fraud-v01
      namespace: edgetraining
    spec:
      predictor:
        model:
          modelFormat:
            name: onnx
            version: "1"
          runtime: ovms-server-01
          storage:
            key: aws-connection-my-storage
            path: modelv01/
  
  - apiVersion: datasciencepipelinesapplications.opendatahub.io/v1alpha1
    kind: DataSciencePipelinesApplication
    metadata:
      finalizers:
      - datasciencepipelinesapplications.opendatahub.io/finalizer
      name: pipelines-definition
      namespace: edgetraining
    spec:
      apiServer:
        applyTektonCustomResource: true
        archiveLogs: false
        autoUpdatePipelineDefaultVersion: true
        collectMetrics: true
        dbConfigConMaxLifetimeSec: 120
        deploy: true
        enableOauth: true
        enableSamplePipeline: false
        injectDefaultScript: true
        stripEOF: true
        terminateStatus: Cancelled
        trackArtifacts: true
      database:
        mariaDB:
          deploy: true
          pipelineDBName: mlpipeline
          pvcSize: 10Gi
          username: mlpipeline
      objectStorage:
        externalStorage:
          bucket: pipeline-artifacts
          host: minio-service.minio.svc:9000
          port: ''
          s3CredentialsSecret:
            accessKey: AWS_ACCESS_KEY_ID
            secretKey: AWS_SECRET_ACCESS_KEY
            secretName: aws-connection-pipeline-artifacts
          scheme: http
          secure: false
      persistenceAgent:
        deploy: true
        numWorkers: 2
      scheduledWorkflow:
        cronScheduleTimezone: UTC
        deploy: true

EOF



```



```