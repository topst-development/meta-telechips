FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

do_install:append() {
    export PKGLIBDIR="${base_libdir}/bootchart"
}
