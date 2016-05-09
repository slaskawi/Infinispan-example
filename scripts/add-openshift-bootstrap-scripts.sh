#!/bin/bash -e

SCRIPT_DIR=$(dirname $0)
INFINISPAN_HOME=/opt/jboss/infinispan-server

function copy-bootstrap() {
  echo "==== COPYING BOOTSTRAP FILES ===="
  cp -r $SCRIPT_DIR/openshift-bootstrap/* $INFINISPAN_HOME/bin
}

function update-permissions() {
  echo "==== UPDATING PERMISSIONS ===="
  chmod +x $INFINISPAN_HOME/bin/*.sh
}

copy-bootstrap
update-permissions