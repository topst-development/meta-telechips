FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://daemon.conf \
			file://client.conf \
			${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'file://pulseaudio.service', '', d)} \
			file://tc_set.pa \
"

inherit features_check

REQUIRED_DISTRO_FEATURES = "systemd"

SYSTEMD_PACKAGES = "${PN}-server"
SYSTEMD_SERVICE:${PN}-server = "pulseaudio.service"

# If apply y2038, utils/padsp.c has been compile error
EXTRA_OEMESON += "-Doss-output=disabled"

do_install:append() {
	install -d ${D}${sysconfdir}/pulse
	install -m 0755 ${WORKDIR}/daemon.conf ${D}${sysconfdir}/pulse/
	install -m 0755 ${WORKDIR}/client.conf ${D}${sysconfdir}/pulse/
	install -m 0755 ${WORKDIR}/tc_set.pa ${D}${sysconfdir}/pulse/

	install -d ${D}/${systemd_unitdir}/system
	install -m 644 ${WORKDIR}/pulseaudio.service ${D}/${systemd_unitdir}/system
}
