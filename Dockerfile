FROM jupyter/minimal-notebook:latest

USER root

# install java
RUN apt-get update && apt-get install -y --no-install-recommends \
    default-jdk \
    make

# install latest version of maven
# maven is required for pathling python api
ENV MAVEN_VERSION=3.8.5
RUN wget https://dlcdn.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz -P /tmp && \
    tar xf /tmp/apache-maven-*.tar.gz -C /opt && \
    ln -s /opt/apache-maven-${MAVEN_VERSION} /opt/maven

# define env vars
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV PATH=$JAVA_HOME/bin:$PATH
ENV M2_HOME=/opt/maven
ENV MAVEN_HOME=${M2_HOME}
ENV PATH=${M2_HOME}/bin:${PATH}

RUN mvn -version

# must match with spark-version from spark-container
ENV SPARK_VERSION=3.2.1
ENV SPARK_SCALA_VERSION=2.12

# python-version from spark must match version form jupyter / client (python 3.8)
# create conda env with python 3.8
RUN conda install python=3.8 
RUN pip install pyspark==${SPARK_VERSION} pandas

# install pathling api
# https://github.com/aehrc/pathling/tree/issue/452/lib/python#development-setup
#RUN git clone -b issue/452 https://github.com/aehrc/pathling.git
RUN git clone -b issue/452 https://github.com/kapsner/pathling.git
RUN cd pathling && \
    mvn -q clean install -pl lib/python -am

# define submit-args (this is working now 2.5.2022 lorenz)
ENV PYSPARK_SUBMIT_ARGS=" \
    --packages org.apache.spark:spark-sql-kafka-0-10_$SPARK_SCALA_VERSION:$SPARK_VERSION \
    pyspark-shell"

USER jovyan
