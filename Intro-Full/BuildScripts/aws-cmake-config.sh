#!/bin/bash -ex
## assume default is openmp
BUILD_TYPE=openmp
if [ "$1" != "" ]; then
   BUILD_TYPE=$1
fi
CUDA_SWITCH=OFF
CUDA_SWITCH_UVM=OFF
OPENMP_SWITCH=ON
COMPILER_NAME=g++
if [ "$BUILD_TYPE" == "cuda" ]; then
   CUDA_SWITCH=ON
   OPENMP_SWITCH=OFF
   COMPILER_NAME=nvcc_wrapper
   if [ "$2" == "uvm" ]; then
      CUDA_SWITCH_UVM=ON
   fi 
fi
if [ "$BUILD_TYPE" == "openmp" ]; then
   OPENMP_SWITCH=ON
fi
CURRENT_PATH=`pwd`
if [[ ! "$CURRENT_PATH" == *build-$BUILD_TYPE* ]]; then
  if [ ! -d build-$BUILD_TYPE ]; then
     mkdir build-$BUILD_TYPE
  fi
  cd build-$BUILD_TYPE
fi
cmake $HOME/Kokkos/kokkos \
-DCMAKE_INSTALL_PREFIX=$HOME/Kokkos/kokkos-cmake-install-$BUILD_TYPE \
-DKokkos_ENABLE_CUDA=${CUDA_SWITCH} \
-DKokkos_ENABLE_OPENMP=${OPENMP_SWITCH} \
-DKokkos_ENABLE_SERIAL=ON \
-DKokkos_ENABLE_TESTS=OFF \
-DCMAKE_CXX_COMPILER=${COMPILER_NAME} \
-DKokkos_ARCH_BDW=ON \
-DKokkos_ARCH_VOLTA70=${CUDA_SWITCH} \
-DKokkos_ENABLE_DEPRECATED_CODE=OFF \
-DKokkos_ENABLE_CUDA_LAMBDA=${CUDA_SWITCH} \
-DKokkos_ENABLE_CUDA_UVM=${CUDA_SWITCH_UVM} \
-DCMAKE_CXX_FLAGS="-O3 -g"
if [ $? == 0 ]; then
   if [ $BUILD_TYPE == "cuda" ]; then
      export KOKKOS_TUTORIAL_CMAKE_CMD="-DCMAKE_CXX_COMPILER=nvcc_wrapper -DKokkos_DIR=/home/ec2-user/Kokkos/kokkos-cmake-install-cuda/lib64/cmake/Kokkos ."
   fi
   if [ $BUILD_TYPE == "openmp" ]; then
      export KOKKOS_TUTORIAL_CMAKE_CMD="-DCMAKE_CXX_COMPILER=g++ -DKokkos_DIR=/home/ec2-user/Kokkos/kokkos-cmake-install-openmp/lib64/cmake/Kokkos ."
   fi
fi
