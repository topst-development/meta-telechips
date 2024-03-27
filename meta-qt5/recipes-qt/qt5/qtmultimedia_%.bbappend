FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
	file://0101-set-alsa-device-tccout-tccin.patch \
"

PACKAGECONFIG:append = " gstreamer"

