SUMMARY = "Telechips Core packages for Linux/GNU runtime images"
DESCRIPTION = "The minimal set of packages required to boot the Telechips System"
PR = "r17"

inherit packagegroup

RDEPENDS:${PN} = "\
	${@bb.utils.contains('TCC_BSP_FEATURES', 'TEE', ' kernel-module-tzdrv tzos', '', d)} \
	${@bb.utils.contains('TCC_BSP_FEATURES', 'HDA', ' kernel-module-hciph hciph', '', d)} \
	${@bb.utils.contains('TCC_BSP_FEATURES', 'optee', 'optee', '', d)} \
"
