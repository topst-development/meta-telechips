SUMMARY = "Wayland IVI Extension"
DESCRIPTION = "GENIVI Layer Management API based on Wayland IVI Extension"
HOMEPAGE = "http://projects.genivi.org/wayland-ivi-extension"
BUGTRACKER = "http://bugs.genivi.org/enter_bug.cgi?product=Wayland%20IVI%20Extension"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=1f1a56bb2dadf5f2be8eb342acf4ed79"

SRCREV = "641a541c15785c004c61065a5044a8db3fe4255c"

SRC_URI = "git://github.com/GENIVI/${BPN}.git;protocol=https;branch=master \
           file://0001-CMakeLists-update-libweston-to-version-10.patch \
    "

S = "${WORKDIR}/git"

DEPENDS = "weston virtual/libgles2 pixman wayland-native"

inherit cmake pkgconfig

FILES:${PN} += "${datadir}/wayland-protocols/stable/ivi-application/ivi-application.xml"
FILES:${PN} += "${libdir}/weston/*"
FILES:${PN}-dbg += "${libdir}/weston/.debug/*"

EXTRA_OECMAKE += "-DLIB_SUFFIX=${@d.getVar('baselib').replace('lib', '')}"

# Need these temporarily to prevent a non-fatal do_package_qa issue
INSANE_SKIP:${PN} += "dev-deps"
INSANE_SKIP:${PN}-dev += "dev-elf dev-so"
