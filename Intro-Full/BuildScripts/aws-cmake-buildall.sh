#!/bin/bash

CM_SCRIPT=$0
TUTORIALS_PATH=`dirname $CM_SCRIPT`/../
pushd ${TUTORIALS_PATH}
./BuildScripts/aws-cmake-config.sh openmp
pushd ./build-openmp
make -j
make install
popd
./BuildScripts/aws-cmake-config.sh cuda
pushd ./build-cuda
make -j
make install
popd
./BuildScripts/aws-cmake-config.sh cuda  uvm
pushd ./build-cuda-uvm
make -j
make install
popd
