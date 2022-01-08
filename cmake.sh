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
if [ "$1" = "--install-deb" ]; then
    shift
    do_install_deb=1
fi
if [ "$1" = "--install-rpm" ]; then
    shift
    do_install_rpm=1
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

if [ "$do_install_deb" = 1 ]; then
    echo && echo "Installing DEB..."
    sudo dpkg -i ./addnum-"$version"-Linux.deb
    ldd /usr/bin/addnumapp

    echo && echo "Running installed program..."
    echo -n "1 + 2 = ..."
    addnumapp
fi

if [ "$do_install_rpm" = 1 ]; then
    echo && echo "Installing RPM..."
    sudo rpm --reinstall --nodeps ./addnum-"$version"-Linux.rpm
    ldd /usr/bin/addnumapp

    echo && echo "Running installed program..."
    echo -n "1 + 2 = ..."
    addnumapp
fi
