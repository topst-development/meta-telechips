FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'file://connman.service', '', d)}"

do_install:append() {
	if ${@bb.utils.contains('DISTRO_FEATURES','systemd','true','false',d)}; then
		install -m 0644 ${WORKDIR}/connman.service ${D}${systemd_unitdir}/system/
		sed -i 's%\(^.*/sbin/ifconfig.*\)MY_MAC_ADDRESS%\1${MY_MAC_ADDRESS}%g' ${D}${systemd_unitdir}/system/connman.service
	else
		sed -i 's%\(^\s*/sbin/ifconfig.*\)MY_MAC_ADDRESS%\1${MY_MAC_ADDRESS}%g' ${D}${sysconfdir}/init.d/connman
	fi
}

PACKAGECONFIG = "wispr ${@bb.utils.contains('DISTRO_FEATURES', 'systemd','systemd', '', d)}"
RDEPENDS:${PN}:append = " connman-tests dhcp-client"
