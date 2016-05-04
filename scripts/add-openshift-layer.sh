#!/bin/bash -e

SCRIPT_DIR=$(dirname $0)
INFINISPAN_HOME=/opt/jboss/infinispan-server
MODULES_HOME=$SCRIPT_DIR/openshift-layer

function copy-modules() {
  echo "==== COPYING MODULES ===="
  cp -r $MODULES_HOME/* $INFINISPAN_HOME
}

function download-modules() {
  echo "==== DOWNLOADING BINARIES ===="
  download-binary "http://central.maven.org/maven2/net/oauth/core/oauth/20100527/oauth-20100527.jar" $INFINISPAN_HOME/modules/system/layers/openshift/net/oauth/core/main
  download-binary "http://central.maven.org/maven2/org/projectodd/openshift/ping/openshift-ping-common/1.0.0.Beta7-swarm-1/openshift-ping-common-1.0.0.Beta7-swarm-1.jar" $INFINISPAN_HOME/modules/system/layers/openshift/org/openshift/ping/main
  download-binary "http://central.maven.org/maven2/org/projectodd/openshift/ping/openshift-ping-kube/1.0.0.Beta7-swarm-1/openshift-ping-kube-1.0.0.Beta7-swarm-1.jar" $INFINISPAN_HOME/modules/system/layers/openshift/org/openshift/ping/main
  download-binary "http://central.maven.org/maven2/org/projectodd/openshift/ping/openshift-ping-dns/1.0.0.Beta7-swarm-1/openshift-ping-dns-1.0.0.Beta7-swarm-1.jar" $INFINISPAN_HOME/modules/system/layers/openshift/org/openshift/ping/main
  download-binary "http://central.maven.org/maven2/org/jgroups/jgroups/3.6.9.Final/jgroups-3.6.9.Final.jar" $INFINISPAN_HOME/modules/system/layers/openshift/org/jgroups/main
}

function download-binary() {
  URL=$1
  DIR=$2
  wget -q -N -P $DIR $URL
}

copy-modules
download-modules