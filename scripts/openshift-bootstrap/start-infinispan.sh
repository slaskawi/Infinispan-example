#!/bin/bash -e

# The server external IP address
SERVER_IP=`ip a s | sed -ne '/127.0.0.1/!{s/^[ \t]*inet[ \t]*\([0-9.]\+\)\/.*$/\1/p}'`
DEBUG=""
DEFAULT_USER=ispn
DEFAULT_PASSWORD=ispn

function check-view-pods-permission() {
    if [ -z "${OPENSHIFT_KUBE_PING_NAMESPACE+x}" ]; then
        echo "Setting default namespace"
        # Replace with target namespace if needed. Currently we are using the same project which was used for the build.
        export OPENSHIFT_KUBE_PING_NAMESPACE=${OPENSHIFT_BUILD_NAMESPACE}
    fi

    if [ -z "${OPENSHIFT_KUBE_PING_LABELS+x}" ]; then
        echo "Setting default labels"
        # Reaplce with labels for infinispan cluster. Empty string means that all pods should be included.
        export OPENSHIFT_KUBE_PING_LABELS=""
    fi

    echo "==== Checking permissions ===="
    echo "Openshift namespace: ${OPENSHIFT_KUBE_PING_NAMESPACE}"
    echo "Openshift pod labels: ${OPENSHIFT_KUBE_PING_LABELS}"

    pods_url="https://${KUBERNETES_SERVICE_HOST:-kubernetes.default.svc}:${KUBERNETES_SERVICE_PORT:-443}/api/${OPENSHIFT_KUBE_PING_API_VERSION:-v1}/namespaces/${OPENSHIFT_KUBE_PING_NAMESPACE}/pods"
    pods_auth="Authorization: Bearer $(cat /var/run/secrets/kubernetes.io/serviceaccount/token)"
    pods_code=$(curl -s -o /dev/null -w "%{http_code}" -G --data-urlencode "${OPENSHIFT_KUBE_PING_LABELS}" -k -H "${pods_auth}" ${pods_url})
    if [ "${pods_code}" -ne "200" ]; then
        echo "Service account not properly configured. Check permissions. Error code ${pods_code}"
        exit 1
    fi

    echo "Openshift permission check pass"
}

function turn-on-debug-if-needed() {
    if [ -z "$OPENSHIFT_DEBUG" ]; then
        DEBUG=""
    else
        DEBUG="--debug"    
    fi
}

function add-user() {
  if [[ -z "${INFINSPAN_USER+x}" || -z "${INFINSPAN_PASSWORD+x}" ]]; then
      echo "Setting default user"
      INFINSPAN_USER=DEFAULT_USER
      INFINSPAN_PASSWORD=DEFAULT_PASSWORD
  fi
  /opt/jboss/infinispan-server/bin/add-user.sh -u $INFINSPAN_USER -p $INFINSPAN_PASSWORD -r ManagementRealm -e -s
}


check-view-pods-permission
turn-on-debug-if-needed
add-user

/opt/jboss/infinispan-server/bin/standalone.sh $DEBUG -c clustered-openshift.xml \
  -b ${SERVER_IP} \
  -bmanagement ${SERVER_IP}