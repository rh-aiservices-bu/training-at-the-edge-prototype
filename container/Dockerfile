# FROM  quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:95b359257a7716b5f8d3a672081a84600218d8f58ca720f46229f7bb893af2ab
# FROM quay.io/modh/odh-generic-data-science-notebook@sha256:f1c285f88f37abb0d54efc1941f349dfed824896568bcd359770e15d78fdb9f9
FROM quay.io/modh/odh-minimal-notebook-container@sha256:c87a41b5ea4dfab158347f6f7d0c6a60a65c6d56e6d1a0f69c9ed12d762f7a10

# Copying custom packages
COPY requirements.txt ./


RUN echo "Installing softwares and packages" && \
    # Install Python packages \
    pip install -r ./requirements.txt && \
    echo 'done with pip install'

WORKDIR /opt/app-root/bin

COPY --chown=1001:0 utils utils/

WORKDIR /opt/app-root/src