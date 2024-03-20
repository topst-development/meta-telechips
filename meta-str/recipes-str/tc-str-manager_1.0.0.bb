FILESEXTRAPATHS_prepend = "${THISDIR}/${PN}/${TCC_MACHINE_FAMILY}:"
DESCRIPTION = "Write application ready for STR"
SECTION = "applications"
LICENSE = "Telechips"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta-telechips/meta-core/licenses/Telechips;md5=e23a23ed6facb2366525db53060c05a4"

SRC_URI = "${TELECHIPS_AUTOMOTIVE_APP_GIT}/tc-str-manager.git;protocol=${ALS_GIT_PROTOCOL};branch=${ALS_BRANCH} \
		   file://suspend-resume.sh \
		   ${@oe.utils.conditional('UPDATE_RCD', 'systemd', 'file://tc-str-manager.service', 'file://tc-str-manager.init.sh',d)} \
	"

COMPATIBLE_MACHINE = "tcc805x"

SRCREV = "288a9272536fb8bda0f275551f8b6e03e514587b"

UPDATE_RCD := "${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'systemd', 'update-rc.d', d)}"

inherit autotools pkgconfig ${UPDATE_RCD}

PATCHTOOL = "git"
RDEPENDS_${PN} += "bash"
S = "${WORKDIR}/git"

# for systemd
SYSTEMD_PACKAGES = "${PN}"
SYSTEMD_SERVICE_${PN} = "tc-str-manager.service"

# for sysvinit
INIT_NAME = "tc-str-manager"

INITSCRIPT_NAME = "${INIT_NAME}"
INITSCRIPT_PARAMS = "start 99 S . stop 30 0 1 6 ."

do_install_append() {
	if ${@bb.utils.contains('DISTRO_FEATURES', 'sysvinit', 'true', 'false', d)}; then
		install -d ${D}${sysconfdir}/init.d
		install -m 0755 ${WORKDIR}/tc-str-manager.init.sh ${D}${sysconfdir}/init.d/${INIT_NAME}	
	else
		install -d ${D}/${systemd_unitdir}/system
		install -d ${D}/${bindir}
		install -m 644 ${WORKDIR}/tc-str-manager.service ${D}/${systemd_unitdir}/system
	fi

	install -d ${D}/${sysconfdir}/str
	install -m 0755 ${WORKDIR}/suspend-resume.sh ${D}/${sysconfdir}/str/
}

FILES_${PN} += " \
		${datadir} \
		${@bb.utils.contains('DISTRO_FEATURES', 'systemd', '${systemd_unitdir}', '', d)} \
"

