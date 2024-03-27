FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://securetty-telechips"

do_configure:prepend () {
    cat ${WORKDIR}/securetty-telechips >> ${WORKDIR}/securetty
}
