################################################################################
#      This file is part of LibreELEC - http://www.libreelec.tv
#      Copyright (C) 2016-present Team LibreELEC
#
#  LibreELEC is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
#
#  LibreELEC is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with LibreELEC.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

PKG_MK="$ROOT/packages/devel/libcec/package.mk"

PKG_NAME="libcec"
PKG_VERSION="$(grep ^PKG_VERSION $PKG_MK | awk -F '=' '{print $2}' | sed 's/["]//g' )"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://libcec.pulse-eight.com/"
PKG_URL="$(grep ^PKG_URL $PKG_MK | awk -F '=' '{print $2}' | sed 's/["]//g' )"
PKG_DEPENDS_TARGET="$(grep ^PKG_DEPENDS_TARGET $PKG_MK | awk -F '=' '{print $2}' | sed 's/["]//g' )"
PKG_PRIORITY="optional"
PKG_SECTION="system"
PKG_SHORTDESC="libCEC is an open-source dual licensed library designed for communicating with the Pulse-Eight USB - CEC Adaptor"
PKG_LONGDESC="libCEC is an open-source dual licensed library designed for communicating with the Pulse-Eight USB - CEC Adaptor."

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

if [ "$KODIPLAYER_DRIVER" = "bcm2835-driver" ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET bcm2835-driver"
fi

if [ "$KODIPLAYER_DRIVER" = "libfslvpuwrap" ]; then
  EXTRA_CMAKE_OPTS="$EXTRA_CMAKE_OPTS -DHAVE_IMX_API=1"
else
  EXTRA_CMAKE_OPTS="$EXTRA_CMAKE_OPTS -DHAVE_IMX_API=0"
fi

if [ "$KODIPLAYER_DRIVER" = "libamcodec" ]; then
  if [ "$PROJECT" = "Odroid_C2" ]; then
    EXTRA_CMAKE_OPTS="$EXTRA_CMAKE_OPTS -DHAVE_AOCEC_API=1"
  else
    EXTRA_CMAKE_OPTS="$EXTRA_CMAKE_OPTS -DHAVE_AMLOGIC_API=1"
  fi
else
  EXTRA_CMAKE_OPTS="$EXTRA_CMAKE_OPTS -DHAVE_AOCEC_API=0 -DHAVE_AMLOGIC_API=0"
fi

if [ "$KODIPLAYER_DRIVER" = "odroid-mfc" ]; then
  EXTRA_CMAKE_OPTS="$EXTRA_CMAKE_OPTS -DHAVE_EXYNOS_API=1"
else
  EXTRA_CMAKE_OPTS="$EXTRA_CMAKE_OPTS -DHAVE_EXYNOS_API=0"
fi

configure_target() {
  if [ "$KODIPLAYER_DRIVER" = "bcm2835-driver" ]; then
    export CXXFLAGS="$CXXFLAGS \
      -I$SYSROOT_PREFIX/usr/include/interface/vcos/pthreads/ \
      -I$SYSROOT_PREFIX/usr/include/interface/vmcs_host/linux"

    # detecting RPi support fails without -lvchiq_arm
    export LDFLAGS="$LDFLAGS -lvchiq_arm"
  fi

  cmake -DCMAKE_TOOLCHAIN_FILE=$CMAKE_CONF \
        -DBUILD_SHARED_LIBS=1 \
        -DCMAKE_INSTALL_PREFIX=/usr \
        -DCMAKE_INSTALL_LIBDIR=/usr/lib \
        -DCMAKE_INSTALL_LIBDIR_NOARCH=/usr/lib \
        -DCMAKE_INSTALL_PREFIX_TOOLCHAIN=$SYSROOT_PREFIX/usr \
        -DCMAKE_PREFIX_PATH=$SYSROOT_PREFIX/usr \
        $EXTRA_CMAKE_OPTS \
        ..
}

post_makeinstall_target() {
  if [ -d $INSTALL/usr/lib/python2.7/dist-packages ]; then 
    mv $INSTALL/usr/lib/python2.7/dist-packages $INSTALL/usr/lib/python2.7/site-packages
  fi
}