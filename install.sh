#! /bin/bash

# Install the dbs and RestClient packages from dmwm/DBS

if [ ! -d dbs_src ]
then

    git clone --branch DBS_3_3_150 --depth 1 https://github.com/dmwm/DBS.git dbs_src

    mv dbs_src/PycurlClient/src/python/RestClient RestClient
    mv dbs_src/Client/src/python/dbs dbs

    # I don't use this doc at the moment
    rm -rf dbs_src/doc

    # Patch dbsClient for documentation
    patch dbs/apis/dbsClient.py dbsClient.patch

fi

# If we're working on readthedocs, we need to use these dummy versions of cjson and pycurl

if [ "$READTHEDOCS" = "True" ]
then

    echo "Adding softlinks to dummy packages."

    ln -s docs/cjson cjson
    ln -s docs/pycurl pycurl

    ls

fi
