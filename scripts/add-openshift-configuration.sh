#!/bin/bash -e

SCRIPT_DIR=$(dirname $0)
INFINISPAN_HOME=/opt/jboss/infinispan-server
CONFIGURATION_HOME=$SCRIPT_DIR/openshift-configuration
BASE_CONFIG_FILE=clustered.xml
OPENSHIFT_CONFIG_FILE=clustered-openshift.xml
PATCH_NAME=clustered-openshift.patch
CONFIG_PATCH=$CONFIGURATION_HOME/$PATCH_NAME

function make-configuration() {
  echo "==== MAKING CONFIGURATION ===="
  #cp $INFINISPAN_HOME/standalone/configuration/$BASE_CONFIG_FILE $INFINISPAN_HOME/standalone/configuration/$OPENSHIFT_CONFIG_FILE
  #cp $CONFIG_PATCH $INFINISPAN_HOME/standalone/configuration
  #patch -d $INFINISPAN_HOME/standalone/configuration $OPENSHIFT_CONFIG_FILE -i $PATCH_NAME > /dev/null
  #rm $INFINISPAN_HOME/standalone/configuration/$PATCH_NAME
  cp $CONFIGURATION_HOME/$OPENSHIFT_CONFIG_FILE $INFINISPAN_HOME/standalone/configuration
}

make-configuration