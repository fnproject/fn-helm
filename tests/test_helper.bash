#!/usr/bin/env bash


function teardown(){
    for rel in $(helm ls -q | grep testcluster-) ; do
        echo deleting release ${rel}
        helm del --purge ${rel}
    done
}