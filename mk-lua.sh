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
pacman -S --needed --noconfirm wget
pacman -S --needed --noconfirm $MINGW_PACKAGE_PREFIX-toolchain

mkdir -p $rootdir/build
cd $rootdir/build

rm -rf lua-$arch
wget -nc http://www.lua.org/ftp/lua-5.3.5.tar.gz
rm -rf lua-5.3.5
tar xvf lua-5.3.5.tar.gz
mv lua-5.3.5 lua-$arch

cd lua-$arch
make generic

mkdir -p $rootdir/bin-$arch
mkdir -p $rootdir/lib/lua-$arch
cd $rootdir/build/lua-$arch
cd $rootdir/build/lua-$arch
cd src && install -p -m 0755 lua luac $MINGW_PREFIX/bin
cd $rootdir/build/lua-$arch
cd src && install -p -m 0755 lua luac $rootdir/bin-$arch
cd $rootdir/build/lua-$arch
cd src && install -p -m 0644 lua.h luaconf.h lualib.h lauxlib.h lua.hpp $rootdir/lib/lua-$arch
cd $rootdir/build/lua-$arch
cd src && install -p -m 0644 liblua.a $rootdir/lib/lua-$arch

cd $rootdir
