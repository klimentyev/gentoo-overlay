# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils git-r3

DESCRIPTION="TREPL is a command-line REPL for Torch."
HOMEPAGE="https://github.com/archenroot/trepl"
EGIT_REPO_URI="https://github.com/archenroot/trepl.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc luajit"

COMMON_DEPEND="!luajit? ( >=dev-lang/lua-5.1:= )
		luajit? ( dev-lang/luajit:2= )"
DEPEND="${COMMON_DEPEND}
		>=dev-lang/lua-5.1:=
		dev-lang/luajit:2
		sys-libs/readline
		=sci-libs/torch7-9999"
RDEPEND="${DEPEND}"

BUILD_DIR="${WORKDIR}/${P}/build"

VERBOSE=1
CMAKE_VERBOSE=1

src_configure() {
	local mycmakeargs=(
		"-DLUADIR=$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD $(usex luajit 'luajit' 'lua'))"
		"-DLIBDIR=$($(tc-getPKG_CONFIG) --variable INSTALL_LIB $(usex luajit 'luajit' 'lua'))"
		"-DLUA_BINDIR=$($(tc-getPKG_CONFIG) --variable INSTALL_BIN $(usex luajit 'luajit' 'lua'))"
		"-DLUA_INCDIR=$($(tc-getPKG_CONFIG) --variable INSTALL_INC $(usex luajit 'luajit' 'lua'))"
		"-DLUA_LIBDIR=$($(tc-getPKG_CONFIG) --variable INSTALL_CMOD $(usex luajit 'luajit' 'lua'))"
		"-DSCRIPTS_DIR=$($(tc-getPKG_CONFIG) --variable INSTALL_BIN $(usex luajit 'luajit' 'lua'))"
		"-DLUALIB=`equery files luajit |grep lib64/libluajit | grep .so | awk 'NR==0; END{print}'`"
		"-DLUA=/usr/bin/luajit"
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
}
