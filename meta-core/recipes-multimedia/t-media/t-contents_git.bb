DESCRIPTION = "Telechips T-Contents"
SECTION = "T-Contents"
LICENSE = "Telechips"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta-telechips/meta-core/licenses/Telechips;md5=e23a23ed6facb2366525db53060c05a4"


SRC_URI = "${TELECHIPS_AUTOMOTIVE_MULTIMEDIA_GIT}/t-contents.git;protocol=${ALS_GIT_PROTOCOL};branch=${ALS_BRANCH};"
SRCREV = "${AUTOREV}"

S = "${WORKDIR}/git"
B = "${S}"

PATCHTOOL = "git"
