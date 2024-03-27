DESCRIPTION = "The multimedia set of packages required to boot the Telechips System"
PR = "r17"

inherit packagegroup

RDEPENDS:${PN} = " \
		kernel-modules-vpu \
		t-codec \
		gstreamer1.0-meta-audio \
		gstreamer1.0-meta-video \
		gstreamer1.0-meta-extra \
		t-media-framework-examples \
		${@bb.utils.contains('DISTRO_FEATURES', 'pulseaudio', 'packagegroup-pulseaudio-telechips', '', d)} \
		"
