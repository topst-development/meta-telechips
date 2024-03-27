PACKAGECONFIG = "${@bb.utils.filter('DISTRO_FEATURES', 'opengl wayland x11', d)}"
