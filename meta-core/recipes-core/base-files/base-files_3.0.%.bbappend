FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
	file://fstab \
	file://profile_local.sh \
	file://system-config-users \
"

#hostname = "telechips-${MACHINE}"
hostname = "topst-ai"
dirs755 += "/opt"

do_install:append () {
	rm -f ${D}${sysconfdir}/fstab
	install -m 0644 ${WORKDIR}/fstab ${D}${sysconfdir}/fstab

	if ${@bb.utils.contains('TCC_ARCH_FAMILY', 'tcc897x', 'true', 'false', d)}; then
		sed -i 's%^\(PARTLABEL=data.*\)ext4\(.*\)%\1vfat\2%g'	${D}${sysconfdir}/fstab
	fi

	install -d ${D}${sysconfdir}/profile.d/
	install -m 0755 ${WORKDIR}/profile_local.sh ${D}${sysconfdir}/profile.d/

	if ${@bb.utils.contains('TCC_ARCH_FAMILY', 'tcc807x', 'true', 'false', d)}; then
		if ${@bb.utils.contains('DISTRO_FEATURES', 'vulkan', 'true', 'false', d)}; then
			echo "export VK_ICD_FILENAMES=/usr/share/vulkan/mali_icd.json"								>> ${D}${sysconfdir}/profile.d/profile_local.sh
		fi
	fi

	install -d ${D}${sysconfdir}/sysconfig
	install -m 644 ${WORKDIR}/system-config-users	${D}${sysconfdir}/sysconfig/
	sed -i "s%DATA_PART_FSTYPE%${DATA_PART_FSTYPE}%g"	${D}${sysconfdir}/sysconfig/system-config-users
}

FILES:${PN} += " \
	${sysconfdir} \
"
