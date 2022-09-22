#!/bin/bash
# Requirements:
#   1. Ubuntu 18.04 LTS
#   2. linaro compiler
#     (1) linaro-aarch64-2018.08-gcc8.2
#     (2) linaro-aarch64-2020.09-gcc10.2-linux5.4

NUM_CORE=$(grep processor /proc/cpuinfo | awk '{field=$NF};END{print field+1}')
PROTOC_DIR=/usr/local/protoc-aarch64
ONNX_TOOLCHAIN=toolchain.cmake
WORKING_DIR=$(pwd)

cd $WORKING_DIR/

sudo mkdir -p $ONNX_DEPENDENCIES/
sudo chmod 777 -R $ONNX_DEPENDENCIES/

# 1. protobuf
cd $WORKING_DIR

ONNX_PROTOBUF_VERSION_MAJOR=3
ONNX_PROTOBUF_VERSION_MINOR=18
ONNX_PROTOBUF_VERSION_PATCH=1
ONNX_PROTOBUF="protobuf-\
$ONNX_PROTOBUF_VERSION_MAJOR"."\
$ONNX_PROTOBUF_VERSION_MINOR"."\
$ONNX_PROTOBUF_VERSION_PATCH"
ONNX_PROTOBUF_URL="https://github.com/protocolbuffers/protobuf/archive/refs/tags/v\
$ONNX_PROTOBUF_VERSION_MAJOR"."\
$ONNX_PROTOBUF_VERSION_MINOR"."\
$ONNX_PROTOBUF_VERSION_PATCH".tar.gz

wget $ONNX_PROTOBUF_URL
tar -xvf $WORKING_DIR/v$ONNX_PROTOBUF_VERSION_MAJOR.$ONNX_PROTOBUF_VERSION_MINOR.$ONNX_PROTOBUF_VERSION_PATCH.tar.gz
rm *.tar.gz
cd $WORKING_DIR/$ONNX_PROTOBUF/
mkdir aarch64_build
cd aarch64_build/
cmake ../cmake -G"Unix Makefiles" \
  -DCMAKE_TOOLCHAIN_FILE=$WORKING_DIR/$ONNX_TOOLCHAIN \
  -DCMAKE_INSTALL_PREFIX=$ONNX_DEPENDENCIES \
  -DCMAKE_BUILD_TYPE=Release \
  -Dprotobuf_BUILD_TESTS=OFF
cmake --build . \
  --config Release \
  --target install \
  -- -j$NUM_CORE
export PATH=$PATH:$ONNX_DEPENDENCIES/bin

# 2. [WIP]onnxruntime
cd $WORKING_DIR

git clone git@github.com:microsoft/onnxruntime.git
cd onnxruntime
# to sync the version(3.18.1) with protobuf
git checkout v1.12.1
git submodule sync
git submodule update --init --recursive

cp $WORKING_DIR/tool.cmake ./

cmake -DONNX_CUSTOM_PROTOC_EXECUTABLE=$PROTOC_DIR/bin \
  -DCMAKE_TOOLCHAIN_FILE=tool.cmake
