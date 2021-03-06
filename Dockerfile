FROM jboss/infinispan-server

# Environment variables
ENV JBOSS_IMAGE_NAME="jboss/infinispan-server-openshift" \
    JBOSS_IMAGE_VERSION="1.0" \
    JBOSS_IMAGE_RELEASE="dev"

# Labels
LABEL Name="$JBOSS_IMAGE_NAME" \
      Version="$JBOSS_IMAGE_VERSION" \
      Release="$JBOSS_IMAGE_RELEASE" \
      Architecture="x86_64" \
      BZComponent="jboss-infinispan-server-openshift-docker" \
      io.k8s.description="High performance Data Grid storage by JBoss" \
      io.k8s.display-name="Infinispan" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="datagrid,java,jboss,xpaas" \
      io.openshift.s2i.scripts-url="image:///usr/local/s2i"

# Exposed ports
# 11211 is for Memcached
# 11222 are for Hot Rod
# 8888 is for Kube PING
# 8181 is for Web Sockets
# 8080 is for REST
EXPOSE 11211 11222 8888 8181 8080

USER root

# Install required RPMs
RUN yum install -y \
      wget \
      patch \
      vim \
      iproute \
      mongodb24-mongo-java-driver \
      postgresql-jdbc \
      mysql-connector-java \
      maven hostname \
      && yum clean all

ADD scripts /tmp/scripts

RUN [ "bash", "-x", "/tmp/scripts/add-openshift-layer.sh" ]
RUN [ "bash", "-x", "/tmp/scripts/add-openshift-configuration.sh" ]
RUN [ "bash", "-x", "/tmp/scripts/add-openshift-bootstrap-scripts.sh" ]

RUN chown -R jboss:jboss /opt/jboss
RUN chmod -R a+rwX /opt/jboss

USER jboss

CMD /opt/jboss/infinispan-server/bin/start-infinispan.sh