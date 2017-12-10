cmake \
    -H./ \
    -B./build_wx \
\
    -DSUPRESS_VERBOSE_OUTPUT=OFF \
    -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON \
    -DCMAKE_BUILD_TYPE=Debug \
    -DCMAKE_INSTALL_PREFIX=inst \
\
    && cmake --build ./build_wx -- -j6
