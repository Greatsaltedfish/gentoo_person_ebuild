# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module  git-r3
DESCRIPTION="PGet is a high performance, concurrent file downloader built in Go"
HOMEPAGE="https://github.com/replicate/pget/"
EGIT_REPO_URI="https://github.com/replicate/pget.git"
EGIT_BRANCH="main"
BDEPEND=">=dev-lang/go-1.20.4 dev-vcs/git"
LICENSE="Apache License 2.0"
SLOT="0"
KEYWORDS=" ~amd64"
S="${WORKDIR}"
RESTRICT="mirror"

src_unpack() {
	 git-r3_src_unpack
     cd ${P} || die
	 export GOPROXY=https://goproxy.cn
	 ego mod vendor || die
     export GIT_TAG=$(git describe --tags --abbrev=0 2>/dev/null) || die
     export GIT_TAG_COMMIT=$(git rev-list -n 1 $GIT_TAG 2>/dev/null | cut -c1-7) || die
     export GIT_COMMIT=$(git rev-parse --short HEAD) || die 
     local GIT_DIRTY=$(git diff --quiet && echo 0 || echo 1) ||die 
     if [$GIT_DIRTY -eq 1]; then
               export VERSION="development-$GIT_COMMIT-uncomitted-changes"
     elif [ $(echo $GIT_COMMIT|sed -e 's/ //g') == $(echo $GIT_TAG_COMMIT|sed -e 's/ //g') ]; then
               export VERSION=$GIT_TAG
     else 
                export VERSION="development-$GIT_COMMIT"          
     fi

}

src_compile() {
    cd ${P} || die
    local BUILD_TIME=$(date +%Y-%m-%dT%H:%M:%S%z)     
     ego build -o $PN  -ldflags  "-extldflags '-static' \
      -X github.com/replicate/pget/pkg/version.Version=$VERSION \
      -X github.com/replicate/pget/pkg/version.CommitHash=$GIT_COMMIT \
      -X github.com/replicate/pget/pkg/version.BuildTime=$BUILD_TIME -w"  \
      ./main.go
}

src_install() {
     cd ${P} || die
     dobin $PN

}

