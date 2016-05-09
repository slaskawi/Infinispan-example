#!/bin/bash -e

SCRIPT_DIR=$(dirname $0)
INFINISPAN_HOME=/opt/jboss/infinispan-server
CONFIGURATION_HOME=$SCRIPT_DIR/openshift-configuration
BASE_CONFIG_FILE=clustered.xml
OPENSHIFT_CONFIG_FILE=clustered-openshift.xml
PATCH_NAME=clustered-openshift.patch
CONFIG_PATCH=$CONFIGURATION_HOME/$PATCH_NAME

function make-configuration() {
  echo "==== COPYING CONFIGURATION ===="
  cp $CONFIGURATION_HOME/$OPENSHIFT_CONFIG_FILE $INFINISPAN_HOME/standalone/configuration
}

make-configuration