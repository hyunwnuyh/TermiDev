#!/bin/bash
cmake -Bbuild -H.
cd build
make
cd ..
./tool
