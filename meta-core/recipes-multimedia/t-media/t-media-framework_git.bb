SUMMARY = "T-Media Multimedia Framework"
DESCRIPTION = "This framework and examples are help to playing multimedia contents"
SECTION = "libs"
LICENSE = "Telechips"
LIC_FILES_CHKSUM = "file://license/COPYING;md5=e7310767391cf02890a5e57f185271f3"

DEPENDS = "glib-2.0 virtual/kernel alsa-lib libdrm"

UPDATE_RCD := "${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'systemd', 'update-rc.d', d)}"
inherit cmake pkgconfig ${UPDATE_RCD}

SRC_URI = "${TELECHIPS_AUTOMOTIVE_MULTIMEDIA_GIT}/t-media-framework.git;protocol=${ALS_GIT_PROTOCOL};branch=${ALS_BRANCH}"
SRC_URI += " \
	file://sample.ts \
	file://boot-animation-5s.mp4 \
	file://boot-animation-10s.mp4 \
	file://boot-animation-20s.mp4 \
    file://default \
	file://t-media-bootani.init.sh \
	file://t-media-bootani.service \
"
SRCREV = "d694f9f024f5c16118730fe982607eb06b1d1250"

PATCHTOOL = "git"

S = "${WORKDIR}/git"

PACKAGES =+ "${PN}-bootani ${PN}-examples"

# for systemd
SYSTEMD_PACKAGES = "${PN}-bootani"
SYSTEMD_SERVICE:${PN}-bootani = "t-media-bootani.service"

# for sysvinit
INIT_NAME = "t-media-bootani"
INITSCRIPT_NAME = "${INIT_NAME}"
INITSCRIPT_PARAMS = "start 00 S ."

BOOTANI_VIDEO_RENDER_DEV ?= "/dev/video10"

BOOTANI_TIME ?= "5s"

do_install:append(){
	install -d ${D}${datadir}
	install -m 0644 ${WORKDIR}/sample.ts			${D}${datadir}
	install -m 0644 ${WORKDIR}/boot-animation-${BOOTANI_TIME}.mp4	${D}${datadir}/boot-animation.mp4

	if ${@bb.utils.contains('DISTRO_FEATURES', 'sysvinit', 'true', 'false', d)}; then
		install -Dm 0755 ${WORKDIR}/t-media-bootani.init.sh		${D}${sysconfdir}/init.d/${INIT_NAME}
	else
		install -Dm 644 ${WORKDIR}/t-media-bootani.service		${D}${systemd_unitdir}/system/t-media-bootani.service
	fi

    install -Dm 0644 ${WORKDIR}/default				${D}${sysconfdir}/default/t-media-bootani
	echo VIDEO_RENDER_DEVICE=${BOOTANI_VIDEO_RENDER_DEV} > ${D}${sysconfdir}/default/t-media-bootani
}


FILES:${PN}-bootani = " \
    ${bindir}/basic_player_bootani \
	${datadir}/boot-animation.mp4 \
	${sysconfdir}/t-media-bootnai \
	${@bb.utils.contains('DISTRO_FEATURES', 'systemd', '${systemd_unitdir}', '', d)} \
"

FILES:${PN}-examples = " \
    ${bindir}/jpev_t_media_sample_app \
	${datadir}/sample.ts \
"

RDEPENDS:${PN}-bootani = " \
	t-media-framework \
	kernel-modules-vpu \
	${@bb.utils.contains('TCC_BSP_FEATURES', 'camera', 'tc-enable-r-gear-status', '', d)} \
"

RDEPENDS:${PN}-examples = " \
	t-media-framework \
"

EXTRA_OECMAKE += "-DTARGET_ARCH=${TARGET_ARCH} "
EXTRA_OECMAKE += "-DCHIPSET=${TCC_ARCH_FAMILY} "
EXTRA_OECMAKE += "-DLINUX_KERNEL_DIR=${STAGING_KERNEL_DIR} "
EXTRA_OECMAKE += "-DCMAKE_BUILD_TYPE=RELEASE "
EXTRA_OECMAKE += " ${@bb.utils.contains('INVITE_PLATFORM', 'support-4k-video', '-DSUPPORT_4K_VIDEO=enable', '-DSUPPORT_4K_VIDEO=disable', d)}"
