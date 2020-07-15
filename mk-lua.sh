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
pacman -S --needed --noconfirm wget
pacman -S --needed --noconfirm $MINGW_PACKAGE_PREFIX-toolchain

mkdir -p $rootdir/build
cd $rootdir/build

rm -rf lua-$MSYSTEM_CARCH
wget -nc http://www.lua.org/ftp/lua-5.3.5.tar.gz
rm -rf lua-5.3.5
tar xvf lua-5.3.5.tar.gz
mv lua-5.3.5 lua-$MSYSTEM_CARCH

cd lua-$MSYSTEM_CARCH
make generic

mkdir -p $rootdir/bin-$MSYSTEM_CARCH
mkdir -p $rootdir/lib/lua-$MSYSTEM_CARCH
cd $rootdir/build/lua-$MSYSTEM_CARCH
cd $rootdir/build/lua-$MSYSTEM_CARCH
cd src && install -p -m 0755 lua luac $MINGW_PREFIX/bin
cd $rootdir/build/lua-$MSYSTEM_CARCH
cd src && install -p -m 0755 lua luac $rootdir/bin-$MSYSTEM_CARCH
cd $rootdir/build/lua-$MSYSTEM_CARCH
cd src && install -p -m 0644 lua.h luaconf.h lualib.h lauxlib.h lua.hpp $rootdir/lib/lua-$MSYSTEM_CARCH
cd $rootdir/build/lua-$MSYSTEM_CARCH
cd src && install -p -m 0644 liblua.a $rootdir/lib/lua-$MSYSTEM_CARCH

cd $rootdir
