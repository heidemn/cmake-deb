#!/bin/bash
set -ex
cd "$(dirname "$0")"

if [ "$1" = "--clean" ]; then
    shift
    rm -rf build
fi
if [ "$1" = "--install" ]; then
    shift
    do_install=1
fi

mkdir -p build
cd build

cmake ..
cmake --build .
cpack

dpkg -c ./addnum-0.2.0-Linux.deb

if [ "$do_install" = 1 ]; then
    sudo dpkg -i ./addnum-0.2.0-Linux.deb
    #LD_LIBRARY_PATH=./install ./install/addnumapp
    /usr/bin/addnumapp
fi
