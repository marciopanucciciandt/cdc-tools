#!/bin/bash

__activate() {
	. .venv/bin/activate
}

setup_precommit() {
    DIR_VENV=.venv
    if [ ! -d "$DIR_VENV" ]; then
        mkdir $DIR_VENV
    else
        rm -rf $DIR_VENV/*
    fi
    python3 -m venv $DIR_VENV &&
        $DIR_VENV/bin/pip install --upgrade pip &&
        $DIR_VENV/bin/pip install -r requirements.txt &&
        __activate &&
        pre-commit install
}

build_image() {
    IMAGE_NAME=${1?'Name of image'}
    DIR_DATALAKE='datalake'
    DIR_NOTEBOOK='notebook'

    if [ ! -d "$DIR_DATALAKE" ]; then
        mkdir $DIR_DATALAKE
    fi

    if [ ! -d "$DIR_NOTEBOOK" ]; then
        mkdir $DIR_NOTEBOOK
    fi

    docker build -t $IMAGE_NAME .

}

start_jupyter() {
    IMAGE_NAME=${1?'Name of image'}
    build_image $IMAGE_NAME
    docker run \
        -it \
        --rm \
        -p 8090:8888 \
        -v $PWD/:/home/jovyan/work \
        $IMAGE_NAME \
        start.sh jupyter lab --LabApp.token=''
}

"$@"
exit
