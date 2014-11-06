# Containerized Oracle XE 11g

This repo contains a [Dockerfile](https://www.docker.com/) to create an image with [Oracle Database 11g Express Edition](http://www.oracle.com/technetwork/database/database-technologies/express-edition/overview/index.html) running in [CentOS 7](http://www.centos.org/)

## Why one more Docker image for Oracle XE?

The main reason for this repo is to have clean and transparent Dockerfile, without any magic behind. It is based on [official CentOS images](https://registry.hub.docker.com/_/centos/) and the build is completely described in the Dockerfile. Unlike many other images on the Net this one uses stock rpm installer provided by Oracle, not repacked by `alien`.

## How to build

Let's assume that you are familar with Docker and building Docker images from [Dockerfiles](http://docs.docker.com/reference/builder/).

1. Download the [rpm installer](http://www.oracle.com/technetwork/database/database-technologies/express-edition/downloads/index.html).
1. Unzip it and pack `oracle-xe-11.2.0-1.0.x86_64.rpm` in `tar.gz` archive named `oracle-xe-11.2.0-1.0.x86_64.rpm.tar.gz` so that it's contents look like:

        % tar -tf oracle-xe-11.2.0-1.0.x86_64.rpm.tar.gz
        oracle-xe-11.2.0-1.0.x86_64.rpm

1. ...or you can simply download prepared tar.gz [here](https://github.com/madhead/docker-oracle-xe/releases/download/v1.0.0/oracle-xe-11.2.0-1.0.x86_64.rpm.tar.gz).
1. Place the tarball inside the `rpm` directory of this repo.
1. Run `docker build -t "madhead/docker-oracle-xe" .` from the root directory of this repo.
1. You should get your image ready in a few minutes (apart from downloading base `centos:centos7` image).

During the configuration of Oracle XE instance two files - `init.ora` and `initXETemp.ora` - are overridden with ones from `config` directory of this repo. The only difference is that `memory_target` parameter is commented in them to prevent `ORA-00845: MEMORY_TARGET not supported on this system` error. The only piece of magic in this image :). 

## How to use

Basically `docker run -p 8089:8080 -p 1521:1521 -d  madhead/docker-oracle-xe` will start new container and bind it's local ports `1521` and `8080` to host's `1521` and `8089` respectively. Read [Docker documentation](http://docs.docker.com/userguide/usingdocker/) for details.

Oracle Web Management Console (apex) will be available at [http://localhost:8089/apex](http://localhost:8089/apex). Use the following credentials to login:

    workspace: INTERNAL
    user: ADMIN
    password: oracle

Connect to the database using the following details:

    hostname: localhost
    port: 1521
    sid: XE
    username: system
    password: oracle

## Known issues

To build and use this image your host machine need to have at least 2GB of swap. This is an Oracle XE limitation, described [here](http://docs.oracle.com/cd/E17781_01/install.112/e18802/toc.htm#XEINL106). It is not possible to use `swapon` command from inside the container to increase swap space due to security reasons. If you know how to bypass this, please share the knowledge with me.
