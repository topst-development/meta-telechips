DESCRIPTION = "Telechips T-Util"
SECTION = "T-Util"
LICENSE = "Telechips"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta-telechips/meta-core/licenses/Telechips;md5=e23a23ed6facb2366525db53060c05a4"


inherit cmake pkgconfig

DEPENDS = "glib-2.0"

SRC_URI = "${TELECHIPS_AUTOMOTIVE_MULTIMEDIA_GIT}/t-util.git;protocol=${ALS_GIT_PROTOCOL};branch=${ALS_BRANCH};"
SRCREV = "${AUTOREV}"

S = "${WORKDIR}/git"
B = "${S}"

PATCHTOOL = "git"
#PACKAGE_ARCH = "${MACHINE_ARCH}"


EXTRA_OECMAKE += "-DLINUX_KERNEL_DIR=${STAGING_KERNEL_DIR}"
EXTRA_OECMAKE += "-DCHIPSET=${TCC_ARCH_FAMILY}"
EXTRA_OECMAKE += "-DCHIPSET_CORE=${TCC_MACHINE_FAMILY}"
EXTRA_OECMAKE += "-DLINUX_KERNEL_VERSION=${LINUX_VERSION}"


FILES:${PN} += " \
	${libdir}/*.so \
"

FILES_SOLIBSDEV = ""
INSANE_SKIP:${PN} += "dev-so"
