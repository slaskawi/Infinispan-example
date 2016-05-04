#!/bin/bash -ex

INFINISPAN_HOME=../infinispan-server-8.2.1.Final
MODULES_HOME=./openshift-layer
CONFIGURATION_HOME=./openshift-configuration
BASE_CONFIG_FILE=clustered.xml
OPENSHIFT_CONFIG_FILE=clustered-openshift.xml
PATCH_NAME=clustered-openshift.patch
CONFIG_PATCH=$CONFIGURATION_HOME/$PATCH_NAME

function copy-modules() {
  echo "==== COPYING MODULES ===="
  cp -r $MODULES_HOME/* $INFINISPAN_HOME
}

function make-configuration() {
  echo "==== MAKING CONFIGURATION ===="
  cp $INFINISPAN_HOME/standalone/configuration/$BASE_CONFIG_FILE $INFINISPAN_HOME/standalone/configuration/$OPENSHIFT_CONFIG_FILE
  cp $CONFIG_PATCH $INFINISPAN_HOME/standalone/configuration
  patch -d $INFINISPAN_HOME/standalone/configuration $OPENSHIFT_CONFIG_FILE -i $PATCH_NAME > /dev/null
  rm $INFINISPAN_HOME/standalone/configuration/$PATCH_NAME
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
make-configuration