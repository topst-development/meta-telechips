#DISTRO_NAME = "Telechips Baseline (Poky/meta-telechips/meta-core)"
DISTRO_NAME = "TOPST AI Baseline (Poky/meta-telechips/meta-core)"
DISTRO_VERSION = "4.0.8"
MAINTAINER = "Telechips System IVI Team <thshin@telechips.com>"

TCMODE ?= "default"
EXTERNAL_TOOLCHAIN ?= ""
TARGET_VENDOR = "-telechips"
TCLIBCAPPEND = ""
TELECHIPS_LINUX_SDK_VERSION ?= "TELECHIPS_BSP_K5.10_1.0.0"
TELECHIPS_LINUX_SDK_RELEASE_DATE ?= "2023/08/25"

ALS_BRANCH ??= "TOPST-AI"
ALS_GIT_PROTOCOL ??= "ssh"
ALS_TIME_ZONE ??= "Asia/Seoul"

# Add virtual providers
PREFERRED_PROVIDER_virtual/crypt ?= "glibc"
PREFERRED_PROVIDER_virtual/nativesdk-crypt ?= "nativesdk-glibc"
PREFERRED_PROVIDER_virtual/kernel ?= "linux-telechips"
PREFERRED_PROVIDER_virtual/libomxil ?= "libomxil-telechips"

# Add virtual runtime providers
VIRTUAL-RUNTIME_libomxil ?= "libomxil-telechips"

# Add recipe providers
PREFERRED_PROVIDER_audiomanager ?= "${@bb.utils.contains('DISTRO_FEATURES', 'pulseaudio', 'audiomanager', 'tc-audio-manager', d)}"

# Add preferred versions
PREFERRED_VERSION_linux-telechips = "${LINUX_VERSION}"
PREFERRED_VERSION_linux-libc-headers = "${LINUXLIBCVERSION}"
PREFERRED_VERSION_mesa ?= "22.%"
PREFERRED_VERSION_wayland ?= "1.20.0"
PREFERRED_VERSION_wayland-native ?= "1.20.0"
PREFERRED_VERSION_nativesdk-wayland ?= "1.20.0"
PREFERRED_VERSION_weston ?= "10.%"

# Add default distro features
DISTRO_FEATURES_DEFAULT = "acl alsa argp debuginfod ext2 largefile opengl pam usbgadget usbhost wayland xattr zeroconf"
DISTRO_FEATURES_BACKFILL:remove = "pulseaudio"

GCCVERSION ?= "arm-9.2"
SDK_NAME = "${DISTRO}-${TCLIBC}-${SDK_ARCH}-${IMAGE_BASENAME}-${TUNE_PKGARCH}"
SDKPATH = "/opt/${DISTRO}/${SDK_VERSION}"

DEFAULT_USER_NAME ?= "topstai"
DEFAULT_GROUP_NAME ?= "topstai"
DEFAULT_PASSWORD ?= "topstai"
DEFAULT_ROOT_PASSWORD ?= "root"

#set image block size to 4096 because default block size of UFS is 4096.
EXTRA_IMAGECMD:append = " -b 4096"

IMAGE_LINGUAS ?= "en-us en-gb"
ENABLE_BINARY_LOCALE_GENERATION ?= "1"
IMAGE_FEATURES ?= ""
IMAGE_FEATURES:remove = "${@bb.utils.contains('EXTRA_IMAGE_FEATURES', 'ssh-server-openssh', 'read-only-rootfs', '', d)}"

# This is a list of packages that are used by the build system to build the distribution, they are not
# directly part of the distribution.
HOSTTOOLS_WHITELIST_GPL-3.0 ?= ""

# Set of commercial licenses whitelist
LICENSE_FLAGS_ACCEPTED += "commercial_gstreamer1.0-omx"

# Set of common licenses used for license.bbclass
INCOMPATIBLE_LICENSE ?= "GPL-3.0-only GPL-3.0-or-later AGPL-3.0-only AGPL-3.0-or-later LGPL-3.0-only LGPL-3.0-or-later SSPL-1.0"

# Advertisement text insertion license
#INCOMPATIBLE_LICENSE += "BSD-4-Clause BSD-4-Clause-Shortened BSD-4-Clause-UC Apache-1.0 OpenSSL ZPL-1.1 Caldera Interbase-1.0 \
#						 MIT-advertising NRL RSCPL TORQUE-1.1 Zend-2.0 CPAL-1.0"

LICENSE_CREATE_PACKAGE = "1"

BUILDCFG_VARS += "LINUX_VERSION KBUILD_DEFCONFIG TCC_BSP_FEATURES IMAGE_FEATURES SDKIMAGE_FEATURES"
BUILDCFG_VARS += "GCCVERSION"
BUILDCFG_VARS += "GLIBCVERSION"

# Bump the connection timeout to 5 minutes to overcome slow proxy servers
FETCHCMD_wget = "/usr/bin/env wget -t 2 -T 300 -nv --passive-ftp --no-check-certificate"

TELECHIPS_AUTOMOTIVE_GIT ?= "git://git@github.com/topst-development"
TELECHIPS_AUTOMOTIVE_BSP_GIT ?= "git://git@github.com/topst-development"
TELECHIPS_AUTOMOTIVE_UTILS_GIT ?= "git://git@github.com/topst-development"
TELECHIPS_AUTOMOTIVE_GRAPHICS_GIT ?= "git://git@github.com/topst-development"
TELECHIPS_AUTOMOTIVE_MULTIMEDIA_GIT ?= "git://git@github.com/topst-development"
TELECHIPS_AUTOMOTIVE_APP_GIT ?= "git://git@github.com/topst-development"
TELECHIPS_AUTOMOTIVE_COMMERCIAL_GIT ?= "git://git@github.com/topst-development"
TELECHIPS_AUTOMOTIVE_TEE_GIT ?= "git://git@github.com/topst-development"

PREMIRRORS ??= " \
bzr://.*/.*   http://downloads.yoctoproject.org/mirror/sources/ \n \
cvs://.*/.*   http://downloads.yoctoproject.org/mirror/sources/ \n \
git://.*/.*   http://downloads.yoctoproject.org/mirror/sources/ \n \
gitsm://.*/.* http://downloads.yoctoproject.org/mirror/sources/ \n \
hg://.*/.*    http://downloads.yoctoproject.org/mirror/sources/ \n \
osc://.*/.*   http://downloads.yoctoproject.org/mirror/sources/ \n \
p4://.*/.*    http://downloads.yoctoproject.org/mirror/sources/ \n \
svn://.*/.*   http://downloads.yoctoproject.org/mirror/sources/ \n \
"

MIRRORS =+ " \
ftp://.*/.*      http://downloads.yoctoproject.org/mirror/sources/ \n \
http://.*/.*     http://downloads.yoctoproject.org/mirror/sources/ \n \
https://.*/.*    http://downloads.yoctoproject.org/mirror/sources/ \n \
"

SOURCE_MIRROR_URL ?= "http://downloads.yoctoproject.org/mirror/sources/"
SSTATE_MIRRORS ?= " \
				    file://.* ${SSTATE_MIRROR_URL}/PATH \n \
				  "
# Disable connectivity check for can build without network environment
CONNECTIVITY_CHECK_URIS = ""

# add invite_platform_check
INHERIT += "rm_work invite_platform_check"
RM_WORK_EXCLUDE += "lk lk-dt lk-tcc u-boot u-boot-tcc initramfs-telechips-image linux-telechips kernel-devsrc boot-firmware"
RM_WORK_EXCLUDE += "tc-enable-removable-disk tcc-vpu"
RM_WORK_EXCLUDE += "telechips-ivi-image-minimal telechips-ivi-image-gstreamer \
					telechips-ivi-image-qt telechips-ivi-image telechips-ivi-image-update"
RM_WORK_EXCLUDE += "meta-toolchain-telechips meta-toolchain-telechips-ivi meta-toolchain-telechips-qt5"
RM_WORK_EXCLUDE += "liblog logcat"
RM_WORK_EXCLUDE += "libcdk-video libcdk-audio libcdk-demux libomxil-telechips telechips-egl mesa powervr powervr-app t-media-framework"
RM_WORK_EXCLUDE += "gstreamer1.0 gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-telechips gstreamer1.0-omx "
RM_WORK_EXCLUDE += "libtcconnect libtcutils libtcdbgen libtcipcctrl"
RM_WORK_EXCLUDE += "tc-audio-manager audiomanager audiomanager-demo tc-micom-manager tc-mode-manager tc-str-manager tc-vcp-manager"
RM_WORK_EXCLUDE += "tc-launcher tc-media-playback tmplayer tmplayer-gui navit"
RM_WORK_EXCLUDE += "hsm"

# refer to poky distro in meta-yocto layer
# QA check settings - a little stricter than the OE-Core defaults
WARN_TO_ERROR_QA = "already-stripped compile-host-path install-host-path \
                    ldflags pn-overrides rpaths staticdev \
                    useless-rpaths"
WARN_QA:remove = "${WARN_TO_ERROR_QA} host-user-contaminated unhandled-features-check"
ERROR_QA:append = " ${WARN_TO_ERROR_QA}"

ERROR_TO_WARN_QA = "pkgconfig version-going-backwards"
ERROR_QA:remove = "${ERROR_TO_WARN_QA}"
WARN_QA:append = " ${ERROR_TO_WARN_QA}"
