#!/bin/bash -e

SCRIPT_DIR=$(dirname $0)
INFINISPAN_HOME=/opt/jboss/infinispan-server

function copy-bootstrap() {
  echo "==== COPYING FILES ===="
  cp -r $SCRIPT_DIR/openshift-bootstrap/* $INFINISPAN_HOME/bin
}

copy-bootstrap