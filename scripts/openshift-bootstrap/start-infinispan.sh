#!/bin/bash -e

# Replace with target namespace if needed. Currently we are using the same project which was used for the build.
export OPENSHIFT_KUBE_PING_NAMESPACE=${OPENSHIFT_BUILD_NAMESPACE}

# Reaplce with labels for infinispan cluster. Empty string means that all pods should be included.
export OPENSHIFT_KUBE_PING_LABELS=""

# The server external IP address
export SERVER_IP=`ip a s | sed -ne '/127.0.0.1/!{s/^[ \t]*inet[ \t]*\([0-9.]\+\)\/.*$/\1/p}'`

function check_view_pods_permission() {
    if [ -n "${OPENSHIFT_KUBE_PING_NAMESPACE}" ]; then
        pods_url="https://${KUBERNETES_SERVICE_HOST:-kubernetes.default.svc}:${KUBERNETES_SERVICE_PORT:-443}/api/${OPENSHIFT_KUBE_PING_API_VERSION:-v1}/namespaces/${OPENSHIFT_KUBE_PING_NAMESPACE}/pods"
        pods_auth="Authorization: Bearer $(cat /var/run/secrets/kubernetes.io/serviceaccount/token)"
        pods_code=$(curl -s -o /dev/null -w "%{http_code}" -G --data-urlencode "${OPENSHIFT_KUBE_PING_LABELS}" -k -H "${pods_auth}" ${pods_url})
        if [ "${pods_code}" -ne "200" ]; then
            echo "Service account not properly configured. Check permissions. Error code ${pods_code}"
            exit 1
        fi
    else
        echo "Environment variable OPENSHIFT_KUBE_PING_NAMESPACE undefined."
        exit 1
    fi
}

/opt/jboss/infinispan-server/bin/standalone.sh -c clustered-openshift.xml \
  -b ${SERVER_IP} \
  -bmanagement ${SERVER_IP}