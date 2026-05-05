#!/bin/bash

set -euxo pipefail

mkdir build
cd build

export CMAKE_PREFIX_PATH="$PREFIX"
export CMAKE_SYSTEM_PREFIX_PATH="$PREFIX"

# Match the cppinterop recipe style. These emscripten-forge defaults can
# sometimes inject flags that are not friendly to LLVM/Clang CMake projects.
# unset EM_FORGE_OPTFLAGS
# unset EM_FORGE_DBGFLAGS
# unset EM_FORGE_LDFLAGS_BASE
# unset EM_FORGE_CFLAGS_BASE
# unset EM_FORGE_SIDE_MODULE_LDFLAGS
# unset EM_FORGE_SIDE_MODULE_CFLAGS

# unset CFLAGS
# unset CXXFLAGS
# unset LDFLAGS

emcmake cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_PREFIX_PATH="$PREFIX" \
    -DCMAKE_INSTALL_PREFIX="$PREFIX" \
    -DCMAKE_CXX_STANDARD=17 \
    -DLLVM_DIR="$PREFIX/lib/cmake/llvm" \
    -DClang_DIR="$PREFIX/lib/cmake/clang" \
    -DLLVM_EXTERNAL_LIT="$(which lit || true)" \
    -DBUILD_SHARED_LIBS=ON \
    -DCLAD_DISABLE_TESTS=ON \
    -DCLAD_ENABLE_BENCHMARKS=OFF \
    -DCLAD_INCLUDE_DOCS=OFF \
    -DCLAD_ENABLE_DOXYGEN=OFF \
    -DCLAD_ENABLE_SPHINX=OFF \
    -DCLAD_ENABLE_ENZYME_BACKEND=OFF \
    "$SRC_DIR"

emmake make -j1
emmake make install
