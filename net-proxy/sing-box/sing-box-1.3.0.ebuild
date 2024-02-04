# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module systemd

DESCRIPTION="sing-box,The universal proxy platform."
HOMEPAGE="https://github.com/SagerNet/sing-box"
SRC_URI="https://github.com/SagerNet/sing-box/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz  
         https://github.com/Greatsaltedfish/gentoo-go-deps/releases/download/${P}/${P}-deps.tar.xz" 
DEPEND=">=dev-lang/go-1.20.4"
RDEPEND="${DEPEND}
         systemd? (
             acct-group/sing-box
             acct-user/sing-box
         )
		openrc? (
               app-misc/jq
		)
"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS=" ~amd64"
S="${WORKDIR}"
RESTRICT="mirror"

IUSE="+quic +grpc reality_server acme clash_api v2ray_api +gvisor tor lwip dhcp wireguard shadowsocksr ech +utls  systemd openrc"
REQUIRED_USE="quic? ( || ( ech utls ) )"

src_compile() {
##   cd ${P} || die 
   local C_TAGS
   if use lwip || use tor; then
             export CGO_CPPFLAGS="$CPPFLAGS"
             export CGO_CFLAGS="$CFLAGS"
             export CGO_CXXFLAGS="$CXXFLAGS"
             export CGO_LDFLAGS="$LDFLAGS" 
   fi
   if use quic; then
             C_TAGS="with_quic,"
   fi
   if use grpc; then
             C_TAGS+="with_grpc,"
   fi
   if use reality_server; then
             C_TAGS+="with_reality_server,"
   fi
   if use acme; then
             C_TAGS+="with_acme,"
   fi
   if use clash_api; then
             C_TAGS+="with_clash_api,"
   fi       
   if use v2ray_api; then
             C_TAGS+="with_v2ray_api,"
   fi 
   if use gvisor; then
             C_TAGS+="with_gvisor," 
   fi   
   if use tor; then
            C_TAGS+="with_embedded_tor," 
   fi 
   if use lwip; then
             C_TAGS+="with_lwip," 
   fi
   if use dhcp; then 
             C_TAGS+="with_dhcp,"
   fi
   if use wireguard; then
             C_TAGS+="with_wireguard,"
   fi
   if use shadowsocksr; then
             C_TAGS+="with_shadowsocksr,"
   fi
   if use ech; then
             C_TAGS+="with_ech," 
   fi
   if use utls; then
             C_TAGS+="with_utls,"
   fi
                
	C_TAGS=$(echo "${C_TAGS}"|sed -E "s/,$//g" || die)  
    ego build \
        -v \
        -trimpath \
        -buildmode=pie \
        -mod=readonly \
        -modcacherw \
        -tags "$C_TAGS" \
        -ldflags "
            -X \"github.com/sagernet/sing-box/constant.Version=${PV} \"
            -s -w -buildid= -linkmode=external" \
        ./cmd/sing-box   

}

src_install() {
##      cd ${P} || die 
      dobin sing-box
      
      if use systemd; then
      systemd_dounit  "${FILESDIR}/sing-box.service" 
      systemd_dounit  "${FILESDIR}/sing-box@.service"
      fi
    
	 if use openrc; then
      newinitd "${FILESDIR}/sing-box.initd" sing-box
      fi

      keepdir /etc/sing-box

}


