# Copyright 2007, Christopher Covington <covracer@gmail.com>
# Copyright 2008, Alexander Simonov <alex@simonov.in.ua>
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Yaws is a high performance HTTP 1.1 web server."
HOMEPAGE="http://yaws.hyber.org/"
SRC_URI="http://yaws.hyber.org/download/${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~amd64"
IUSE=""

DEPEND="dev-lang/erlang"

RESTRICT="primaryuri"

src_unpack() {
	unpack ${A}
	find ${S} -depth -type d -name .xvpics -exec rm -rf '{}' \;
}

src_compile() {
	econf --prefix=/usr --sysconfdir=/etc
	emake
}

src_install() {
	make DESTDIR=${D} install || edie
	# Use /var/log and not /var/lib/log for Yaws logging directory
	rm -rf ${D}/var/lib/log
	sed -i 's%/var/lib/log%/var/log%g' ${D}/etc/yaws.conf || enotice "check log dir in config file"
	keepdir /var/log/yaws
	# We need to keep these directories so that the example yaws.conf works
	# properly
	keepdir /usr/lib/yaws/examples/ebin
	keepdir /usr/lib/yaws/examples/include
	dodoc ChangeLog LICENSE README
}
