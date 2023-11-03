# training-at-the-edge-prototype

Research project to illustrate training/serving at the edge

intructions:
* be `oc` authenticated as cluster-admin against an OpenShift cluster
* Clone the project and move into the deploy sub-directory:
    ```bash
    cd /tmp
    git clone https://github.com/rh-aiservices-bu/training-at-the-edge-prototype.git
    cd training-at-the-edge-prototype/deploy
    bash -x 01.deploy.everything.sh
    ```
* Wait for environment to stabilize
* Consult DS project called "edgetraining"

