#!/bin/bash
# Requirements:
#   1. Ubuntu 18.04 LTS
#   2. linaro compiler
#     (1) linaro-aarch64-2018.08-gcc8.2
#     (2) linaro-aarch64-2020.09-gcc10.2-linux5.4

NUM_CORE=$(grep processor /proc/cpuinfo | awk '{field=$NF};END{print field+1}')
WORKING_DIR=$(pwd)
ONNXRUNTIME_PREFIX=/usr/local/onnxruntime-aarch64/

export PATH=/usr/local/linaro-aarch64-2020.09-gcc10.2-linux5.4/bin/:$PATH
export CC=aarch64-linux-gnu-gcc
export CXX=aarch64-linux-gnu-g++

sudo mkdir $ONNXRUNTIME_PREFIX
sudo chmod 777 -R $ONNXRUNTIME_PREFIX

# 1. protobuf
cd $WORKING_DIR

ONNX_PROTOBUF_VERSION_MAJOR=3
ONNX_PROTOBUF_VERSION_MINOR=18
ONNX_PROTOBUF_VERSION_PATCH=1
ONNX_PROTOBUF="protobuf-\
$ONNX_PROTOBUF_VERSION_MAJOR"."\
$ONNX_PROTOBUF_VERSION_MINOR"."\
$ONNX_PROTOBUF_VERSION_PATCH"
ONNX_PROTOBUF_URL="https://github.com/protocolbuffers/protobuf/releases/download/v\
$ONNX_PROTOBUF_VERSION_MAJOR"."\
$ONNX_PROTOBUF_VERSION_MINOR"."\
$ONNX_PROTOBUF_VERSION_PATCH"/protoc-"\
$ONNX_PROTOBUF_VERSION_MAJOR"."\
$ONNX_PROTOBUF_VERSION_MINOR"."\
$ONNX_PROTOBUF_VERSION_PATCH"-linux-x86_64.zip

wget $ONNX_PROTOBUF_URL
unzip $WORKING_DIR/protoc-$ONNX_PROTOBUF_VERSION_MAJOR.$ONNX_PROTOBUF_VERSION_MINOR.$ONNX_PROTOBUF_VERSION_PATCH-linux-x86_64.zip -d $WORKING_DIR/$ONNX_PROTOBUF
rm *.zip

# 2. [WIP] onnxruntime
cd $WORKING_DIR

# pip uninstall onnx

git clone git@github.com:microsoft/onnxruntime.git
cd onnxruntime
# must match the version of the protoc which is used in onnxruntime that currently using
# git checkout v1.12.0
git pull
git submodule sync
git submodule update --init --recursive

# error: def process_ifs(lines: Iterable[str], onnx_ml: bool) -> Iterable[str]:
# You MUST explicitly modify the Python version you are using for your environment to avoid this error
# 
# $ python3 --version
# Python 3.6.9
cp $WORKING_DIR/CMakeLists.txt $WORKING_DIR/onnxruntime/cmake/external/onnx

mkdir aarch64_build
cd aarch64_build/
cmake ../cmake -G"Unix Makefiles" \
  -DCMAKE_INSTALL_PREFIX=$ONNXRUNTIME_PREFIX \
  -DCMAKE_BUILD_TYPE=Release \
  -DONNX_CUSTOM_PROTOC_EXECUTABLE=$WORKING_DIR/$ONNX_PROTOBUF/bin/protoc \
  -DCMAKE_TOOLCHAIN_FILE=$WORKING_DIR/tool.cmake
# make -j$NUM_CORE
cmake --build . \
  --config Release \
  --target install \
  -- -j$NUM_CORE
