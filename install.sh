#!/bin/bash

ENV_NAME=$1

if [ ! $ENV_NAME ]; then
    echo "[ERROR] Please provide environment name as only argument."
    echo "[ERROR]  $ ./install.sh cc-env-r20190610"
    exit
fi

TOP_DIR=cc-env

rm -fr $TOP_DIR
mkdir -p $TOP_DIR
cd $TOP_DIR/

SETUP_SCRIPT=$PWD/setup_cc_env.sh
export JASPY_BASE_DIR=~/jaspy_base
mkdir -p $JASPY_BASE_DIR

git clone https://github.com/cedadev/jaspy-manager
cd jaspy-manager/

bin/add-envs-repo.sh https://github.com/ncasuk/ncas-jaspy-envs
bin/install-jaspy-env.sh $ENV_NAME

env_dir=$(find $JASPY_BASE_DIR -type d -name $ENV_NAME)
parent_dir=$(dirname $(dirname $env_dir))

cd ../

git clone https://github.com/cedadev/cc-vocab-cache
git clone https://github.com/ncasuk/amf-compliance-checks

rm -f $SETUP_SCRIPT
echo "cd $PWD" >> $SETUP_SCRIPT
echo "export PATH=$parent_dir/bin:\$PATH" >> $SETUP_SCRIPT
echo "source activate $ENV_NAME" >> $SETUP_SCRIPT
echo "export PYESSV_ARCHIVE_HOME=$PWD/cc-vocab-cache/pyessv-archive-eg-cvs" >> $SETUP_SCRIPT

echo "Get started with: "
echo " $ source $SETUP_SCRIPT"

eg_file=$(find $env_dir -name "amf_eg_data_1.nc")
echo
echo "Test with: "
echo " $ compliance-checker --yaml amf-compliance-checks/checks/AMF_file_info.yml --test file_info_checks $eg_file"
