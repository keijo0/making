# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

#inherit savedconfig toolchain-funcs

DESCRIPTION="slstatus"
HOMEPAGE="https://github.com/keijo0/slstatus"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/keijo0/slstatus.git"
else
	SRC_URI="https://github.com/keijo0/d.git"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE=""

src_prepare() {
	default

	sed -i \
		-e "s/ -Os / /" \
		-e "/^\(LDFLAGS\|CFLAGS\|CPPFLAGS\)/{s| = | += |g;s|-s ||g}" \
		-e "/^X11LIB/{s:/usr/X11R6/lib:/usr/$(get_libdir)/X11:}" \
		-e '/^X11INC/{s:/usr/X11R6/include:/usr/include/X11:}' \
		config.mk || die

	restore_config config.h
}

src_compile() {
	if use xinerama; then
		emake CC="$(tc-getCC)" d
	else
		emake CC="$(tc-getCC)" XINERAMAFLAGS="" XINERAMALIBS="" d
	fi
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install


	dodoc README

	save_config config.h
}
