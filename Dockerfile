FROM centos:centos7

LABEL Siarhei Krukau <siarhei.krukau@gmail.com>

ENV ORACLE_HOME /u01/app/oracle/product/11.2.0/xe
ENV ORACLE_SID  XE
ENV PATH        $ORACLE_HOME/bin:$PATH

EXPOSE 1521
EXPOSE 8080

# Pre-requirements
RUN mkdir -p /run/lock/subsys

RUN yum install -y libaio bc initscripts net-tools; \
    yum clean all \
    && mv /usr/bin/free /usr/bin/free.orig

# Install Oracle XE
ADD tmp/oracle-xe-11.2.0-1.0.x86_64.rpm /tmp/
RUN yum localinstall -y /tmp/oracle-xe-11.2.0-1.0.x86_64.rpm; \
    rm -rf /tmp/oracle-xe-11.2.0-1.0.x86_64.rpm \
    && mv /usr/bin/free.orig /usr/bin/free

# Configure instance
ADD config/xe.rsp config/init.ora config/initXETemp.ora /u01/app/oracle/product/11.2.0/xe/config/scripts/
RUN chown oracle:dba /u01/app/oracle/product/11.2.0/xe/config/scripts/*.ora \
                     /u01/app/oracle/product/11.2.0/xe/config/scripts/xe.rsp \
    && chmod 755     /u01/app/oracle/product/11.2.0/xe/config/scripts/*.ora \
                     /u01/app/oracle/product/11.2.0/xe/config/scripts/xe.rsp \
    && /etc/init.d/oracle-xe configure responseFile=/u01/app/oracle/product/11.2.0/xe/config/scripts/xe.rsp

# Run script
ADD config/start.sh /
CMD /start.sh
