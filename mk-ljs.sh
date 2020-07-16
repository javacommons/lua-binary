#! bash
echo MSYSTEM=$MSYSTEM
echo MSYSTEM_CARCH=${MSYSTEM_CARCH}
echo MINGW_PACKAGE_PREFIX=$MINGW_PACKAGE_PREFIX
echo MINGW_PREFIX=$MINGW_PREFIX
if [ "${MSYSTEM_CARCH}" = "i686" ]; then
  arch=x86
else
  arch=x86_64
fi
echo arch=$arch
rootdir=`pwd`
echo rootdir=$rootdir
sleep 3

pacman -S --needed --noconfirm svn
pacman -S --needed --noconfirm make
pacman -S --needed --noconfirm sed
pacman -S --needed --noconfirm $MINGW_PACKAGE_PREFIX-toolchain

mkdir -p $rootdir/build
cd $rootdir/build

rm -rf ljs-$arch
svn export -r 64 https://github.com/mingodad/ljs/trunk ljs-$arch
cd ljs-$arch
make generic

mkdir -p $rootdir/bin-$arch
mkdir -p $rootdir/lib/ljs-$arch
cd $rootdir/build/ljs-$arch
cd src && cp -p liblua.a libljs.a
cd $rootdir/build/ljs-$arch
cd src && install -p -m 0755 ljs ljsc $MINGW_PREFIX/bin
cd $rootdir/build/ljs-$arch
cd src && install -p -m 0755 ljs ljsc $rootdir/bin-$arch
cd $rootdir/build/ljs-$arch
cd src && install -p -m 0644 lua.h luaconf.h lualib.h lauxlib.h lua.hpp $rootdir/lib/ljs-$arch
cd $rootdir/build/ljs-$arch
cd src && install -p -m 0644 libljs.a $rootdir/lib/ljs-$arch

cd $rootdir/build/ljs-$arch
cd lua2ljs
sed -i'.orig' -e 's/fopen(fname, "r")/fopen(fname, "rb")/g' lua-parser.re2c.c
make
install -p -m 0755 lua2ljs $MINGW_PREFIX/bin
install -p -m 0755 lua2ljs $rootdir/bin-$arch

cd $rootdir
