#!/usr/bin/bash

# Compatible version with rules_verilator - check bazelisk installation
#USE_BAZEL_VERSION=5.2.0
#USE_BAZEL_VERSION=4.0.0
USE_BAZEL_VERSION=6.2.0

export VERILOG_SRC_DIR=$PWD/src
export VERILOG_LIB_DIR=$PWD/lib
export VERILOG_TEST_DIR=$PWD/test

export GTKWAVE_APP=/Applications/gtkwave.app/Contents/Resources/bin/gtkwave
export WAVEFORM_FILE="waveform.vcd"
