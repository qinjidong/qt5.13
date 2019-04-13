export PKG_CONFIG_PATH=/usr/lib/x86_64-linux-gnu/pkgconfig

$SRC_DIR/configure --prefix=$INSTALL_DIR -debug -opensource -confirm-license -directfb -fontconfig -no-xcb -nomake tests -proprietary-codecs -v -pkg-config -force-pkg-config -cups -no-evdev -no-dbus -no-eglfs -skip qtconnectivity -skip qtmultimedia -skip qtlocation -skip qtsensors -skip qtwayland -skip qtgamepad -skip qtserialbus

CheckResult

make -j55

CheckResult

make install -j55

CheckResult