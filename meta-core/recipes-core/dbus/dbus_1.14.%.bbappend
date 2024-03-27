FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://system-local.conf"

do_install:append() {
	install -d ${D}${sysconfdir}/dbus-1
    install -m 0644 ${WORKDIR}/system-local.conf ${D}${sysconfdir}/dbus-1	
}
