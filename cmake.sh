#!/bin/bash
set -e
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

echo && echo "Building..."
cmake $my_cmake_opts ..
cmake --build .
cpack

version=$(< ../version.txt)

echo && echo "*.deb contents:"
dpkg -c ./addnum-"$version"-Linux.deb
echo && echo "*.rpm contents:"
rpm -qlpv ./addnum-"$version"-Linux.rpm

if [ "$do_install" = 1 ]; then
    echo && echo "Installing..."
    sudo dpkg -i ./addnum-"$version"-Linux.deb
    ldd /usr/bin/addnumapp

    /usr/bin/addnumapp
fi
