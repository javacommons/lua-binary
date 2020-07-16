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

rm -rf ljsjit-$arch
svn export -r 35 https://github.com/mingodad/ljsjit/trunk ljsjit-$arch

cd ljsjit-$arch
make BUILDMODE=static

mkdir -p $rootdir/bin-$arch
mkdir -p $rootdir/lib/ljsjit-$arch
cd $rootdir/build/ljsjit-$arch
cd src && cp -p libluajit.a libljsjit.a
cd $rootdir/build/ljsjit-$arch
cd src && cp -p luajit.exe ljsjit.exe
cd $rootdir/build/ljsjit-$arch
cd src && install -p -m 0755 ljsjit $MINGW_PREFIX/bin
cd $rootdir/build/ljsjit-$arch
cd src && install -p -m 0755 ljsjit $rootdir/bin-$arch
cd $rootdir/build/ljsjit-$arch
cd src && install -p -m 0644 luajit.h lua.h luaconf.h lualib.h lauxlib.h lua.hpp $rootdir/lib/ljsjit-$arch
cd $rootdir/build/ljsjit-$arch
cd src && install -p -m 0644 libljsjit.a $rootdir/lib/ljsjit-$arch

cd $rootdir
