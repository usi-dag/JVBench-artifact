#!/bin/bash

# $1: configuration, one of [short, full], "full" by default.

. config

mode="full"
if [ $# -gt 0 ]; then
    mode=$1
    if [ ! $mode == "short" ] && [ ! $mode == "full" ]; then
        echo -e "\nInvalid mode provided.\nPlease chose one of [short, full]"
        exit 3
    fi
fi

VOLUME_OUT_DIR=$(pwd)/$SHARED_VOLUME/$mode
RUNNER_OUT_DIR=$VOLUME_OUT_DIR/data/jdk19
FIGURES_OUT_DIR=$VOLUME_OUT_DIR/figures
mkdir -p $VOLUME_OUT_DIR
mkdir -p $RUNNER_OUT_DIR
mkdir -p $FIGURES_OUT_DIR

export JAVA_HOME=$JVBENCH_JAVA_HOME
export PATH=$JAVA_HOME/bin:$PATH

benchmark_runner_folder=$(pwd)/benchmark_runner

python3.9 $benchmark_runner_folder/runner.py -o $RUNNER_OUT_DIR -m dockerimg -conf $benchmark_runner_folder/configurations/$mode/conf.json -jdk $JVBENCH_JAVA_HOME -jvb $JVBENCH_JAR
python3.9 $benchmark_runner_folder/runner.py -pl fma indexInRange pow -p -o $RUNNER_OUT_DIR -m dockerimg -conf $benchmark_runner_folder/configurations/$mode/conf.json -jdk $JVBENCH_JAVA_HOME -jvb $JVBENCH_JAR

export JAVA_HOME=$JVBENCH_JAVA_HOME_XOR
export PATH=$JAVA_HOME/bin:$PATH
export JVBENCH_JAR=$JVBENCH_XOR_JAR

python3.9 $benchmark_runner_folder/runner.py -pl xor -p -o $RUNNER_OUT_DIR -m dockerimg -conf $benchmark_runner_folder/configurations/$mode/xor_conf.json -jdk $JVBENCH_JAVA_HOME_XOR -jvb $JVBENCH_XOR_JAR

cd postprocessing
python3.9 main.py -pprx new -i $RUNNER_OUT_DIR -o $FIGURES_OUT_DIR
