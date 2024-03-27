FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
	file://udevextra.rules \
	${@bb.utils.contains_any('TCC_MACHINE_FAMILY', 'tcc805x-main tcc807x-main', 'file://weston_display.rules', '', d)} \
"

do_install:append() {
    rm -f ${D}${sysconfdir}/udev/rules.d/autonet.rules
	install -m 0644 ${WORKDIR}/udevextra.rules    		${D}${sysconfdir}/udev/rules.d/

	if ${@oe.utils.conditional('BOOT_STORAGE', 'ufs', 'true', 'false', d)}; then
		echo "/dev/sd[a-c]*" >>  ${D}${sysconfdir}/udev/rules.d/mount.ignorelist
	fi

	if ${@bb.utils.contains_any('TCC_MACHINE_FAMILY', 'tcc805x-main tcc807x-main', "true", "false", d)}; then
		install -m 0644 ${WORKDIR}/weston_display.rules     ${D}${sysconfdir}/udev/rules.d/
	fi
}
