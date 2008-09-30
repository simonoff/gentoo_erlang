# Copyright 2007, Christopher Covington <covracer@gmail.com>
# Copyright 2008, Alexander Simonov <alex@simonov.in.ua>
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="An Erlang/Yaws MVC web development framework."
HOMEPAGE="http://erlyweb.org"
SRC_URI="http://erlyweb.googlecode.com/files/${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="doc source"

COMMON_DEP=">=dev-lang/erlang-12.2"
DEPEND="${COMMON_DEP}"
RDEPEND="${COMMON_DEP}
	>=www-servers/yaws-1.77"

RESTRICT="primaryuri"

src_compile() {
	rm ebin/*
	sed -i s%/opt/local/lib/yaws/include%/usr/lib/yaws/include% Emakefile || edie "sed'ing the yaws include failed"
	sh make.sh || edie "make.sh failed"
}

src_install() {
	# binaries
	dodir /usr/lib/erlang/lib/${P}/ebin
	insinto /usr/lib/erlang/lib/${P}/ebin
	doins ebin/*

	# documentation
	dodoc README.txt CHANGELOG.txt
	if use doc ; then
		dohtml doc/*
	fi

	# source code
	if use source ; then
		dodir /usr/lib/erlang/lib/${P}/src
		insinto /usr/lib/erlang/lib/${P}/src
		doins src/*
	fi
}

pkg_postinst() {
	echo
	einfo "To create a new erlyweb app, start yaws in interactive mode and run"
	einfo "'erlyweb:create_app(\"foo\", \"/your/apps/dir\").'."
}
