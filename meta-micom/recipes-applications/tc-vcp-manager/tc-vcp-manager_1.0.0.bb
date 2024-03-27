FILESEXTRAPATHS:append := ":${THISDIR}/${TCC_MACHINE_FAMILY}:"
DESCRIPTION = "Micom Manager Applications for Telechips Linux AVN"
SECTION = "applications"
LICENSE = "Telechips"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta-telechips/meta-core/licenses/Telechips;md5=e23a23ed6facb2366525db53060c05a4"

COMPATIBLE_MACHINE = "tcc807x"

SRC_URI = "${TELECHIPS_AUTOMOTIVE_APP_GIT}/tc-vcp-manager.git;protocol=${ALS_GIT_PROTOCOL};branch=${ALS_BRANCH} \
		  ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'file://tc-vcp-manager.service', 'file://micom-manager.init.sh', d)} \
		  ${@bb.utils.contains('INVITE_PLATFORM', 'str', 'file://suspend-resume.sh', '', d)} \
"

SRCREV = "ea749c6b5cd98b93902c9ee4180a8859555a39a3"

UPDATE_RCD := "${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'systemd', 'update-rc.d', d)}"

inherit autotools pkgconfig ${UPDATE_RCD}

PATCHTOOL = "git"
RDEPENDS:${PN} += "bash"
S = "${WORKDIR}/git"

MACHINE_TYPE = "${@d.getVar("MACHINE").split("-")[1]}"

PACKAGECONFIG ??= "	${@bb.utils.contains_any('MACHINE_TYPE', 'sub', 'core', '', d)} \
					${@bb.utils.contains_any('INVITE_PLATFORM', 'str', 'str', '', d)} \
					"
PACKAGECONFIG[core] = ",--without-subcore,,libgcc"
PACKAGECONFIG[str] = ",--without-str"

# for systemd
SYSTEMD_PACKAGES = "${PN}"
SYSTEMD_SERVICE:${PN} = "tc-vcp-manager.service"

# for sysvinit
INIT_NAME = "micom-manager"

INITSCRIPT_NAME = "${INIT_NAME}"
INITSCRIPT_PARAMS = "start 40 S . stop 20 0 1 6 ."

do_install:append() {
	if ${@bb.utils.contains('DISTRO_FEATURES', 'sysvinit', 'true', 'false', d)}; then
		install -d ${D}${sysconfdir}/init.d
		install -m 0755 ${WORKDIR}/micom-manager.init.sh ${D}${sysconfdir}/init.d/${INIT_NAME}
	else
		install -d ${D}/${systemd_unitdir}/system
		install -m 644 ${WORKDIR}/tc-vcp-manager.service ${D}/${systemd_unitdir}/system
	fi

	if ${@bb.utils.contains('INVITE_PLATFORM', 'str', 'true', 'false', d)}; then
		install -d ${D}/${sysconfdir}/str
		install -m 0755 ${WORKDIR}/suspend-resume.sh ${D}/${sysconfdir}/str/	
	fi

}

FILES:${PN} += " \
		${sysconfdir} \
		${localstatedir} \
		${@bb.utils.contains('DISTRO_FEATURES', 'systemd', '${systemd_unitdir}', '', d)} \
"

RDEPENDS:${PN} += "bash"
