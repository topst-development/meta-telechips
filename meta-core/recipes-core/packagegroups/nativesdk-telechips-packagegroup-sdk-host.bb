SUMMARY = "Host packages for the Telechips Automotive Linux SDK standalone SDK or external toolchain"

PACKAGEGROUP_DISABLE_COMPLEMENTARY = "1"
PACKAGE_ARCH = "${TUNE_PKGARCH}"
inherit packagegroup nativesdk

RDEPENDS:${PN} = " \
	nativesdk-protobuf-compiler \
"
