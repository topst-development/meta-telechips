FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://50-udev-default.rules"

RRECOMMENDS:${PN} += "udev-extraconf"

do_install:append() {
	install -m 0644 ${WORKDIR}/50-udev-default.rules ${D}${base_libdir}/udev/rules.d
}
