################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
#
#  OpenELEC is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
#
#  OpenELEC is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with OpenELEC.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

PKG_MK="$ROOT/packages/x11/lib/libXfixes/package.mk"
PKG_NAME="libXfixes"
PKG_VERSION="$(grep ^PKG_VERSION $PKG_MK | awk -F '=' '{print $2}' | sed 's/["]//g' )"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="http://www.X.org"
PKG_URL="$(grep ^PKG_URL $PKG_MK | awk -F '=' '{print $2}' | sed 's/["]//g' )"
PKG_DEPENDS_TARGET="$(grep ^PKG_DEPENDS_TARGET $PKG_MK | awk -F '=' '{print $2}' | sed 's/["]//g' )"
PKG_PRIORITY="optional"
PKG_SECTION="x11/lib"
PKG_SHORTDESC="libxfixes: X Fixes Library"
PKG_LONGDESC="X Fixes Library"

PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--disable-static --enable-shared"

pre_configure_target() {
  export CFLAGS="$CFLAGS -fPIC"
}
