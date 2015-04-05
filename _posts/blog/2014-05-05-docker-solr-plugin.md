---
date: 2014-05-05
title: Use Docker to develop Solr plugin
category: blog
disqus_id: 2014-05-05-docker-solr-plugin
---

From time to time I have a need to customize Solr a bit more that is's possible using regular configuration.

I those times I tend to create a plug-ins ([UniqueCounter](https://github.com/mrfuxi/UniqueCounter), [TokenMatcher](https://github.com/mrfuxi/TokenMatcher)).

Previously I was using Eclipse, as it was able to run Solr using Jetty. It had obvious advantage of running Solr for me, so I can test my code quickly. On the other side it's a hassle to set up correctly, changing version of Solr is also not easy.

I realized that I need to have a repeatable environment that I can simply dump when plug-in is done and restore if I want to fix/change something. If that would be Python I would just use good old tandem of virtualenv and requirements.txt.

For this occasion I choose [Docker](https://www.docker.io/). That way I can define how env has to be created and the only thing I have to keep this definition. You can say that it would be quite a hassle to define all from scratch (install Java, Solr and so on). You might be right, if it would not be for the Docker community! There are number of containers to choose from and to modify. I used [makuk66/docker-solr](https://index.docker.io/u/makuk66/docker-solr/) as a base (description including version of Solr on side is a bit out of date comparing to [Git repo](https://github.com/makuk66/docker-solr/blob/master/Dockerfile)).

That container gives installed Solr in version to play and needs some extra work in order to use it for development. So I extended it by:

- extracting jars to known location (*/opt/solr_jars*)
- allowing to mount plug-in code (to: */opt/code*)
- allowing to mount core configuration (to: */opt/cores*)

By default when running container you'll get bash in location of your code.
That way environment part is done. Remaining thing is to be able to compile and run Solr with a plug-in. To do that I created rather simple *build.xml*.

At the end of the day I can start new container, build plug-in and run Solr in couple of lines:

```shell
# Build image (1 off)
docker build -t solr_dev .

# Start new container
docker run -i --rm -t -v `pwd`/plugin:/opt/code:rw -P -v `pwd`/cores:/opt/cores/:r -p 8983:8983 solr_dev

# Recompile plug-in and start Solr
ant run
```

---

Below you'll find full definitions of both Docker image and Java build file.

Dockerfile:
```docker
FROM makuk66/docker-solr
MAINTAINER  Karol Duleba "mr.fuxi@gmail.com"

# Dev tools
RUN apt-get -y install ant

# Solr
ENV SOLR_JARS /opt/solr_jars

RUN rm /opt/$SOLR.tgz
RUN apt-get -y install unzip
RUN unzip -q /opt/solr/dist/$SOLR.war "*.jar" -d /tmp/war
RUN mkdir $SOLR_JARS
RUN mv /tmp/war/WEB-INF/lib/*.jar /opt/solr_jars
RUN cp /opt/solr/dist/solrj-lib/*slf4j*.jar /opt/solr_jars

VOLUME ["/opt/code", "/opt/cores"]
WORKDIR /opt/code

EXPOSE 8983

CMD ["/bin/bash"]
```

build.xml:
```java
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<project name="SolrPlugin" basedir="." default="main">
    <property name="src.dir"     value="src"/>
    <property name="build.dir"   value="bin"/>
    <property name="classes.dir" value="${build.dir}/classes"/>
    <property name="jar.dir"     value="${build.dir}/jar"/>
    <property name="lib.dir"     value="../solr_jars"/>
    <property name="jar.name"    value="awasome-plugin"/>

    <path id="classpath">
        <fileset dir="${lib.dir}" includes="**/*.jar"/>
    </path>

    <target name="clean">
        <delete dir="${build.dir}"/>
    </target>

    <target name="compile">
        <mkdir dir="${classes.dir}"/>
        <javac srcdir="${src.dir}" destdir="${classes.dir}" classpathref="classpath" includeantruntime="false" debug="on"/>
    </target>

    <target name="lint">
        <javac srcdir="${src.dir}" destdir="${classes.dir}" classpathref="classpath" includeantruntime="false" debug="on">
            <compilerarg value="-Xlint"/>
        </javac>
    </target>

    <target name="jar" depends="compile">
        <mkdir dir="${jar.dir}"/>
        <jar destfile="${jar.dir}/${jar.name}.jar" basedir="${classes.dir}"/>
    </target>

    <target name="run" depends="jar">
        <java jar="/opt/solr/example/start.jar" fork="true" dir="/opt/solr/example/">
            <jvmarg value="-Dsolr.solr.home=/opt/cores"/>
        </java>
    </target>

    <target name="clean-build" depends="clean,jar"/>
    <target name="main" depends="clean,jar"/>
</project>
```
