FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
    ${@oe.utils.conditional('TCC_ARCH_FAMILY', 'tcc805x', 'file://0001-ref-pp125085.eglfs_pvr.Qt5.6.3.patch.patch', '', d)} \
"

# change opengl option
PACKAGECONFIG_GL = "${@bb.utils.contains('DISTRO_FEATURES', 'opengl', 'gles2', '', d)}"

# accessibility is required to compile qtquickcontrols
PACKAGECONFIG_DEFAULT:append = " alsa glib sql-sqlite accessibility freetype fontconfig xkbcommon-evdev"
PACKAGECONFIG_DEFAULT:append = " ${@bb.utils.contains("DISTRO_FEATURES", "wayland", "mtdev libinput libproxy", "", d)}"

PACKAGECONFIG:append = " ${@bb.utils.contains("ADDITIONAL_QT5_MODULES", "qtwebkit", "icu", "", d)}"
PACKAGECONFIG:append = " eglfs"
PACKAGECONFIG:append = " examples"

QPA_PLATFORM = "${@bb.utils.contains('INVITE_PLATFORM', 'qt5/wayland', 'wayland', \
				bb.utils.contains('INVITE_PLATFORM', 'qt5/eglfs', 'eglfs', 'linuxfb', d), d)} \
"

QT_CONFIG_FLAGS += "-qpa ${QPA_PLATFORM}"
