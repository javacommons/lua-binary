#! bash -uvx
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

rm -rf luajit-$MSYSTEM_CARCH
svn export https://github.com/LuaJIT/LuaJIT/tags/v2.1.0-beta3 luajit-$MSYSTEM_CARCH

cd luajit-$MSYSTEM_CARCH
make BUILDMODE=static

mkdir -p $rootdir/bin-$MSYSTEM_CARCH
mkdir -p $rootdir/lib/luajit-$MSYSTEM_CARCH
cd $rootdir/build/luajit-$MSYSTEM_CARCH
cd src && install -p -m 0755 luajit $MINGW_PREFIX/bin
cd $rootdir/build/luajit-$MSYSTEM_CARCH
cd src && install -p -m 0755 luajit $rootdir/bin-$MSYSTEM_CARCH
cd $rootdir/build/luajit-$MSYSTEM_CARCH
cd src && install -p -m 0644 luajit.h lua.h luaconf.h lualib.h lauxlib.h lua.hpp $rootdir/lib/luajit-$MSYSTEM_CARCH
cd $rootdir/build/luajit-$MSYSTEM_CARCH
cd src && install -p -m 0644 libluajit.a $rootdir/lib/luajit-$MSYSTEM_CARCH

cd $rootdir
