#!/bin/sh
DIR=`dirname $0`
rm -rf \
  $DIR/bin \
  $DIR/include \
  $DIR/lib \
  $DIR/onnxruntime \
  $DIR/protobuf*

