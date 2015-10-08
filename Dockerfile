FROM centos:centos7

MAINTAINER Siarhei Krukau <siarhei.krukau@gmail.com>

# Pre-requirements
RUN mkdir -p /run/lock/subsys

RUN yum install -y libaio bc initscripts net-tools; \
    yum clean all

# Install Oracle XE
ADD rpm/oracle-xe-11.2.0-1.0.x86_64.rpm /tmp/
RUN yum localinstall -y /tmp/oracle-xe-11.2.0-1.0.x86_64.rpm; \
    rm -rf /tmp/oracle-xe-11.2.0-1.0.x86_64.rpm

# Configure instance
ADD config/xe.rsp config/init.ora config/initXETemp.ora /u01/app/oracle/product/11.2.0/xe/config/scripts/
RUN chown oracle:dba /u01/app/oracle/product/11.2.0/xe/config/scripts/*.ora \
                     /u01/app/oracle/product/11.2.0/xe/config/scripts/xe.rsp
RUN chmod 755        /u01/app/oracle/product/11.2.0/xe/config/scripts/*.ora \
                     /u01/app/oracle/product/11.2.0/xe/config/scripts/xe.rsp
ENV ORACLE_HOME /u01/app/oracle/product/11.2.0/xe
ENV ORACLE_SID  XE
ENV PATH        $ORACLE_HOME/bin:$PATH

RUN /etc/init.d/oracle-xe configure responseFile=/u01/app/oracle/product/11.2.0/xe/config/scripts/xe.rsp

# Run script
ADD config/start.sh /
CMD /start.sh

EXPOSE 1521
EXPOSE 8080
