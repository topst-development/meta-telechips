DESCRIPTION = "Target packages for basic of Telechips Automotive Linux SDK"

PACKAGEGROUP_DISABLE_COMPLEMENTARY = "1"
PACKAGE_ARCH = "${TUNE_PKGARCH}"
inherit packagegroup

RDEPENDS:${PN} += "\
	packagegroup-core-standalone-sdk-target \
	libsqlite3-dev \
    expat-dev \
	base-files \
	glib-2.0-dev \
	dbus-dev \
	dbus-glib-dev \
	boost-dev \
	libusb1-dev \
	taglib-dev \
	python3 \
	kernel-devsrc \
	gawk \
    ${@bb.utils.contains('INVITE_PLATFORM', 'multimedia', '${GST_DEP_PACKAGES}', '', d)} \
	${@bb.utils.contains('DISTRO_FEATURES', 'opengl', '${OPENGL_DEP_PACKAGES}', '', d)} \
	${@bb.utils.contains('DISTRO_FEATURES', 'wayland opengl', '${WAYLAND_DEP_PACKAGES}', '', d)} \
"

OPENGL_DEP_PACKAGES = " \
	libegl-dev \
	libgles1-dev \
	libgles2-dev \
	libgles3-dev \
    ${@bb.utils.contains('DISTRO_FEATURES', 'wayland', 'libgbm-dev', '', d)} \
	libsdl2-dev \
"
OPENGL_DEP_PACKAGES:remove:tcc897x = "libgles3-dev"

GST_DEP_PACKAGES = " \
	alsa-dev \
	orc-dev \
	libogg-dev \
	libtheora-dev \
	libvorbis-dev \
	pango-dev \
	libcap-dev \
	cairo-dev \
	flac-dev \
	gdk-pixbuf-dev \
	libpng-dev \
	libsoup-2.4-dev \
	speex-dev \
	curl-dev \
	neon-dev \
	sbc-dev \
	libxml2-dev \
	bzip2-dev \
	librsvg-dev \
	libsndfile1-dev \
	liba52-dev \
"

WAYLAND_DEP_PACKAGES = " \
	libdrm-dev \
	wayland-dev \
	weston-dev \
"
