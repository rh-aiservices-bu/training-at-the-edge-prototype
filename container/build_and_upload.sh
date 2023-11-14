
# podman build
podman build -t sds:v01 .

# podman container run --rm -it --entrypoint=bash sds:v01

podman tag sds:v01 \
            quay.io/egranger/workbench-images/sds:v01

podman push quay.io/egranger/workbench-images/sds:v01
