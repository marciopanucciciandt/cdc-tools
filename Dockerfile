FROM jupyter/pyspark-notebook

#### Install system requirements ####
USER root
RUN apt-get -qq update && \
    apt-get install -y --no-install-recommends apt-utils libpostgresql-jdbc-java libpostgresql-jdbc-java-doc

#### Install python requirements ####
USER $NB_UID
ADD requirements.txt .
RUN pip install --quiet -r requirements.txt && rm -f requirements.txt
