$SRC_DIR/configure --prefix=$INSTALL_DIR -debug -opensource -confirm-license -directfb -nomake tests -proprietary-codecs -v
make -j55 && make install -j55
