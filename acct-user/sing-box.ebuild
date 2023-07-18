# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="Sing-box program user"
ACCT_USER_ID=477
ACCT_USER_GROUPS=( sing-box )
acct-user_add_deps
SLOT="0"

