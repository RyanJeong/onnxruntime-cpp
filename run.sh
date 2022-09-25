#!/bin/bash
# Requirements:
#   1. Ubuntu 18.04 LTS
#   2. linaro compiler
#     (1) linaro-aarch64-2018.08-gcc8.2
#     (2) linaro-aarch64-2020.09-gcc10.2-linux5.4

NUM_CORE=$(grep processor /proc/cpuinfo | awk '{field=$NF};END{print field+1}')
WORKING_DIR=$(pwd)

# 1. protobuf
cd $WORKING_DIR

ONNX_PROTOBUF_VERSION_MAJOR=3
ONNX_PROTOBUF_VERSION_MINOR=18
ONNX_PROTOBUF_VERSION_PATCH=1
ONNX_PROTOBUF="protobuf-\
$ONNX_PROTOBUF_VERSION_MAJOR"."\
$ONNX_PROTOBUF_VERSION_MINOR"."\
$ONNX_PROTOBUF_VERSION_PATCH"
ONNX_PROTOBUF_URL="https://github.com/protocolbuffers/protobuf/releases/download/v3.18.1/protoc-\
$ONNX_PROTOBUF_VERSION_MAJOR"."\
$ONNX_PROTOBUF_VERSION_MINOR"."\
$ONNX_PROTOBUF_VERSION_PATCH"-linux-x86_64.zip

wget $ONNX_PROTOBUF_URL
unzip $WORKING_DIR/protoc-$ONNX_PROTOBUF_VERSION_MAJOR.$ONNX_PROTOBUF_VERSION_MINOR.$ONNX_PROTOBUF_VERSION_PATCH-linux-x86_64.zip -d $WORKING_DIR/$ONNX_PROTOBUF
rm *.zip

# 2. [WIP] onnxruntime
cd $WORKING_DIR

pip uninstall onnx

git clone git@github.com:microsoft/onnxruntime.git
cd onnxruntime
# must match the version of the protoc which is used in onnxruntime that currently using
git checkout v1.12.0
git submodule sync
git submodule update --init --recursive

mkdir aarch64_build
cd aarch64_build/

cmake ../cmake -G"Unix Makefiles" \
  -DONNX_CUSTOM_PROTOC_EXECUTABLE=$WORKING_DIR/$ONNX_PROTOUF/bin/protoc \
  -DCMAKE_TOOLCHAIN_FILE=$WORKING_DIR/tool.cmake
cmake --build . \
  --config Release \
  --target install \
  -- -j$NUM_CORE
