#!/bin/bash
set -ex
cd "$(dirname "$0")"

if [ "$1" = "--clean" ]; then
    shift
    rm -rf build
fi
if [ "$1" = "--static" ]; then
    shift
    my_cmake_opts="-DBUILD_SHARED_LIBS=Off"
fi
if [ "$1" = "--install" ]; then
    shift
    do_install=1
fi

mkdir -p build
cd build

cmake $my_cmake_opts ..
cmake --build .
cpack

dpkg -c ./addnum-0.2.0-Linux.deb

if [ "$do_install" = 1 ]; then
    sudo dpkg -i ./addnum-0.2.0-Linux.deb
    ldd /usr/bin/addnumapp

    /usr/bin/addnumapp
fi
