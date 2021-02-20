#!/bin/bash
set -x

rm -r tmp
CHPL_LOCALE_MODEL=gpu chpl --llvm --ccflags --cuda-gpu-arch=sm_61 test_add.chpl --savec=tmp -L/usr/local/cuda-10.2/lib64 -lcuda

./test_add

