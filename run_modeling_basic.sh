#!/bin/bash

#compile modeling using gfortran
gfortran modeling_basic.f90 -o run_modeling_basic

#run modeling basic
./run_modeling_basic



#visualize results - it's necessary seismic unix

#Snapshots
xmovie n1=301 n2=301 sleep=1 loop=1 < snapshots.bin

#Seismogram
ximage n1=1001 < seismogram.bin

#rm *.bin run_modeling_basic
