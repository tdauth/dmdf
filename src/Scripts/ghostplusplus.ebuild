ESVN_REPO_URI="http://ghostplusplus.googlecode.com/svn/trunk/" ghostplusplus-read-only


# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit cmake-utils subversion

DESCRIPTION="GHost++ is a Warcraft 3 game hosting bot."
HOMEPAGE="http://code.google.com/p/ghostplusplus/"
LICENSE="APL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE="+app +blp +jass jass_llvm +map +mdlx +mpq +w3g +editor +plugins debug doc"

EGIT_REPO_URI="git://wc3lib.org/wc3lib.git"
EGIT_BRANCH="master"

DEPEND="${RDEPEND}"
RDEPEND="
>=dev-libs/boost-1.46
"
MERGE_TYPE="source"

# https://www.ghostpp.com/forum/index.php?topic=346.0
# https://github.com/OHSystem/ohsystem/wiki/Installation---UNIX
src_configure() {
	cd bncsutil/src/bncsutil/
	make
	#make install
	
	# go back
	cd StormLib/stormlib
	make
	make install
	
	# todo replace stuff
	cd ghost/
	make
}