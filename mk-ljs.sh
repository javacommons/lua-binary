#! bash
echo MSYSTEM=$MSYSTEM
echo MSYSTEM_CARCH=$MSYSTEM_CARCH
echo MINGW_PACKAGE_PREFIX=$MINGW_PACKAGE_PREFIX
echo MINGW_PREFIX=$MINGW_PREFIX
rootdir=`pwd`
echo rootdir=$rootdir
sleep 3

pacman -S --needed --noconfirm svn
pacman -S --needed --noconfirm make
pacman -S --needed --noconfirm sed
pacman -S --needed --noconfirm $MINGW_PACKAGE_PREFIX-toolchain

mkdir -p $rootdir/build
cd $rootdir/build

rm -rf ljs-$MSYSTEM_CARCH
svn export -r 64 https://github.com/mingodad/ljs/trunk ljs-$MSYSTEM_CARCH
cd ljs-$MSYSTEM_CARCH
make generic

mkdir -p $rootdir/bin-$MSYSTEM_CARCH
mkdir -p $rootdir/lib/ljs-$MSYSTEM_CARCH
cd $rootdir/build/ljs-$MSYSTEM_CARCH
cd src && cp -p liblua.a libljs.a
cd $rootdir/build/ljs-$MSYSTEM_CARCH
cd src && install -p -m 0755 ljs ljsc $MINGW_PREFIX/bin
cd $rootdir/build/ljs-$MSYSTEM_CARCH
cd src && install -p -m 0755 ljs ljsc $rootdir/bin-$MSYSTEM_CARCH
cd $rootdir/build/ljs-$MSYSTEM_CARCH
cd src && install -p -m 0644 lua.h luaconf.h lualib.h lauxlib.h lua.hpp $rootdir/lib/ljs-$MSYSTEM_CARCH
cd $rootdir/build/ljs-$MSYSTEM_CARCH
cd src && install -p -m 0644 libljs.a $rootdir/lib/ljs-$MSYSTEM_CARCH

cd $rootdir/build/ljs-$MSYSTEM_CARCH
cd lua2ljs
sed -i'.orig' -e 's/fopen(fname, "r")/fopen(fname, "rb")/g' lua-parser.re2c.c
make
install -p -m 0755 lua2ljs $MINGW_PREFIX/bin
install -p -m 0755 lua2ljs $rootdir/bin-$MSYSTEM_CARCH

cd $rootdir
