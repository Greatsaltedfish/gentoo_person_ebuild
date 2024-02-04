# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module systemd git-r3

DESCRIPTION="Deepl local Free API"
HOMEPAGE="https://github.com/OwO-Network/DeepLX"
EGIT_REPO_URI="https://github.com/OwO-Network/DeepLX.git"
EGIT_BRANCH="main"
DEPEND=">=dev-lang/go-1.20.4"
RDEPEND="${DEPEND}"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS=" ~amd64"
S="${WORKDIR}"
RESTRICT="mirror"

src_unpack() {
	 git-r3_src_unpack
     cd ${P} || die
	 export GOPROXY=https://goproxy.cn
	 ego mod vendor || die

}

src_compile() {
     cd ${P} || die
     ego build -a -installsuffix cgo -o deeplx . || die
     

}


src_install() {
          cd ${P} || die
          dobin deeplx
          systemd_dounit "${FILESDIR}/deeplx.service"
}