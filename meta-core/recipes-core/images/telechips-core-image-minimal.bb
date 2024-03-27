#
# Copyright (C) Telechips Inc.
#

inherit tcc-base-image

LINGUAS_KO_KR = "ko-kr ko-kr.euc-kr"
LINGUAS_EN_GB = "en-gb en-gb.iso-8859-1"
LINGUAS_EN_US = "en-us en-us.iso-8859-1"

IMAGE_LINGUAS = "${LINGUAS_KO_KR} ${LINGUAS_EN_GB} ${LINGUAS_EN_US}"

# language
IMAGE_INSTALL += " glibc-gconv-utf-16 glibc-gconv-utf-32"
IMAGE_INSTALL += " glibc-gconv-euc-kr glibc-gconv-libksc"

# kernel modules
IMAGE_INSTALL += "kernel-modules"

# security
IMAGE_INSTALL += "${@bb.utils.contains_any('TCC_BSP_FEATURES', 'TEE HDA optee', ' packagegroup-telechips-security', '', d)}"
IMAGE_INSTALL += "${@bb.utils.contains_any('TCC_ARCH_FAMILY', 'tcc803x tcc805x', ' hsm', '', d)}"

# audio
IMAGE_INSTALL += "alsa-lib alsa-utils alsa-state"

# enable vbus of usb
IMAGE_INSTALL += "tc-enable-removable-disk"
