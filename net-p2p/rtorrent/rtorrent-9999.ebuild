# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/rtorrent/rtorrent-0.9.3.ebuild,v 1.1 2013/03/22 08:29:46 patrick Exp $

EAPI=4

inherit eutils git-2 autotools

DESCRIPTION="BitTorrent Client using libtorrent"
HOMEPAGE="http://libtorrent.rakshasa.no/"
#SRC_URI="http://libtorrent.rakshasa.no/downloads/${P}.tar.gz"
EGIT_REPO_URI="git://github.com/rakshasa/rtorrent.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris"
IUSE="daemon debug ipv6 test xmlrpc"

COMMON_DEPEND="~net-libs/libtorrent-9999
    >=dev-libs/libsigc++-2.2.2:2
    >=net-misc/curl-7.19.1
    sys-libs/ncurses
    xmlrpc? ( dev-libs/xmlrpc-c )"
RDEPEND="${COMMON_DEPEND}
    daemon? ( || ( app-misc/tmux app-misc/screen ) )"
DEPEND="${COMMON_DEPEND}
    test? ( dev-util/cppunit )
    virtual/pkgconfig"

DOCS=( doc/rtorrent.rc )

src_unpack() {
    git-2_src_unpack
}

src_prepare() {
    # bug #358271
    epatch "${FILESDIR}"/${PN}-0.9.1-ncurses.patch

    eautoreconf

    # upstream forgot to include
    cp ${FILESDIR}/rtorrent.1 ${S}/doc/ || die
}

src_configure() {
    # configure needs bash or script bombs out on some null shift, bug #291229
    CONFIG_SHELL=${BASH} econf \
        --disable-dependency-tracking \
        $(use_enable debug) \
        $(use_enable ipv6) \
        $(use_with xmlrpc xmlrpc-c)
}

src_install() {
    default
    doman doc/rtorrent.1

    if use daemon; then
	    elog 'daemon flag set. please create appropriate initscripts yourself'
#        newinitd "${FILESDIR}/rtorrentd.init" rtorrentd
#        newconfd "${FILESDIR}/rtorrentd.conf" rtorrentd
    fi
}
