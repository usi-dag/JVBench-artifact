#!/bin/bash

. config

precollected_output_dir=$(pwd)/$SHARED_VOLUME/figures-paper

mkdir -p $precollected_output_dir
./generate-figures.sh -pprx precollected -i $(pwd)/precollected_data -o $precollected_output_dir
