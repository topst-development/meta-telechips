SUMMARY = "Telechips Core packages for Linux/GNU runtime images"
DESCRIPTION = "The minimal set of packages required to boot the Telechips System"
PR = "r17"

inherit packagegroup

RDEPENDS:${PN} = " \
	${WAYLAND_PACKAGES} \
"

WAYLAND_PACKAGES = " \
	wayland \
	weston \
	weston-init \
	weston-examples \
"
