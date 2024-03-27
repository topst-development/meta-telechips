FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://format-filesystem.service \
            file://format-filesystem.sh \
			file://format-data-partition.service \
			file://format-data-partition.sh \
			file://systemd-udevd.conf \
			file://systemd-udevd.service \
			file://systemd-modules-load.service \
			file://sys-fs-fuse-connections.mount \
			file://sys-kernel-config.mount \
			file://systemd-sysctl.service \
			${@bb.utils.contains('TCC_ARCH_FAMILY', 'tcc750x', '', 'file://01.usb-storage.conf', d)} \
			${@bb.utils.contains('TCC_ARCH_FAMILY', 'tcc750x', '', 'file://02.scsi.conf', d)} \
		    ${@bb.utils.contains('TCC_ARCH_FAMILY', 'tcc750x', '', 'file://03.sdmmc.conf', d)} \
		    ${@bb.utils.contains('TCC_ARCH_FAMILY', 'tcc750x', '', 'file://04.tcc-ehci.conf', d)} \
		    ${@bb.utils.contains('TCC_ARCH_FAMILY', 'tcc750x', '', 'file://05.tcc-ohci.conf', d)} \
			${@bb.utils.contains('TCC_ARCH_FAMILY', 'tcc750x', '', 'file://06.tcc-dwc2.conf', d)} \
		    ${@bb.utils.contains_any('TCC_ARCH_FAMILY', 'tcc803x tcc805x tcc807x', 'file://07.tcc-dwc3.conf', '', d)} \
		    ${@bb.utils.contains('TCC_ARCH_FAMILY', 'tcc750x', '', 'file://08.sound.conf', d)} \
			${@bb.utils.contains('TCC_ARCH_FAMILY', 'tcc750x', '', 'file://09.input.conf', d)} \
			${@bb.utils.contains('TCC_BSP_FEATURES', 'multimedia', 'file://98.vpu.conf', '', d)} \
			${@bb.utils.contains('TCC_BSP_FEATURES', 'multimedia', 'file://99.vpu_ext.conf', '', d)} \
"

EXTRA_OEMESON += "-Ddefault-dnssec=no"

PACKAGECONFIG:remove = "hibernate nss-resolve"
PACKAGECONFIG:remove = "${@bb.utils.contains('TCC_BSP_FEATURES', 'network', '', 'networkd resolved', d)}"

do_install:append() {
# override mountflags of systemd-udevd.service for access mount point its own filesystem namespace
	install -d ${D}${sysconfdir}/systemd/system/systemd-udevd.service.d
	install -m 0644 ${WORKDIR}/systemd-udevd.conf 		${D}${sysconfdir}/systemd/system/systemd-udevd.service.d/
	install -m 0644 ${WORKDIR}/systemd-udevd.service	${D}${systemd_unitdir}/system

# install service file & script file
	install -m 0644 ${WORKDIR}/format-filesystem.service		${D}/${systemd_unitdir}/system
	install -m 0644 ${WORKDIR}/format-data-partition.service	${D}/${systemd_unitdir}/system
	install -m 0755 ${WORKDIR}/format-filesystem.sh 			${D}/${bindir}/
	install -m 0755 ${WORKDIR}/format-data-partition.sh 		${D}/${bindir}/

	install -d ${D}${sysconfdir}/systemd/system/sysinit.target.wants
	install -d ${D}${sysconfdir}/systemd/system/sockets.target.wants
	ln -sf ${systemd_unitdir}/system/format-filesystem.service		${D}${sysconfdir}/systemd/system/sysinit.target.wants/format-filesystem.service
	ln -sf ${systemd_unitdir}/system/format-data-partition.service	${D}${sysconfdir}/systemd/system/sockets.target.wants/format-data-partition.service

# install network configuration
	# change how to load kernel modules from automatic to manual
	sed -i "s%\(ENV{MODALIAS}==\"?\*.*\)%#\1%g" ${D}${base_libdir}/udev/rules.d/80-drivers.rules

	# add modprobe configuration files
	install -d ${D}${sysconfdir}/modules-load.d/
	if ${@bb.utils.contains('TCC_ARCH_FAMILY', 'tcc750x', 'false', 'true', d)}; then
		install -m 0644 ${WORKDIR}/01.usb-storage.conf		${D}${sysconfdir}/modules-load.d/
		install -m 0644 ${WORKDIR}/02.scsi.conf			${D}${sysconfdir}/modules-load.d/

		if  ${@bb.utils.contains_any("TCC_MACHINE_FAMILY", "tcc805x-sub tcc807x-sub", "false", "true", d)}; then
			install -m 0644 ${WORKDIR}/03.sdmmc.conf			${D}${sysconfdir}/modules-load.d/

			if ${@bb.utils.contains_any("TCC_ARCH_FAMILY", "tcc897x tcc803x", "true", "false", d)}; then
				install -m 0644 ${WORKDIR}/04.tcc-ehci.conf		${D}${sysconfdir}/modules-load.d/
				install -m 0644 ${WORKDIR}/05.tcc-ohci.conf		${D}${sysconfdir}/modules-load.d/
			fi

			install -m 0644 ${WORKDIR}/06.tcc-dwc2.conf		${D}${sysconfdir}/modules-load.d/

			if ${@bb.utils.contains_any("TCC_ARCH_FAMILY", "tcc803x tcc805x tcc807x", "true", "false", d)}; then
				install -m 0644 ${WORKDIR}/07.tcc-dwc3.conf		${D}${sysconfdir}/modules-load.d/
			fi

			install -m 0644 ${WORKDIR}/08.sound.conf			${D}${sysconfdir}/modules-load.d/
			install -m 0644 ${WORKDIR}/09.input.conf			${D}${sysconfdir}/modules-load.d/

		else
			install -m 0644 ${WORKDIR}/04.tcc-ehci.conf		${D}${sysconfdir}/modules-load.d/
			install -m 0644 ${WORKDIR}/05.tcc-ohci.conf		${D}${sysconfdir}/modules-load.d/
		fi
	fi

	if ${@bb.utils.contains_any("TCC_MACHINE_FAMILY", "tcc805x-sub tcc807x-sub", "false", "true", d)}; then
		if ${@bb.utils.contains('TCC_BSP_FEATURES', 'multimedia', 'true', 'false', d)}; then
			install -m 0644 ${WORKDIR}/98.vpu.conf		${D}${sysconfdir}/modules-load.d/
			install -m 0644 ${WORKDIR}/99.vpu_ext.conf		${D}${sysconfdir}/modules-load.d/
		fi
	fi
	
	# change order of kernel modules
	install -m 0644 ${WORKDIR}/systemd-modules-load.service ${D}${systemd_unitdir}/system
	install -m 0644 ${WORKDIR}/sys-fs-fuse-connections.mount ${D}${systemd_unitdir}/system
	install -m 0644 ${WORKDIR}/sys-kernel-config.mount ${D}${systemd_unitdir}/system
	install -m 0644 ${WORKDIR}/systemd-sysctl.service ${D}${systemd_unitdir}/system

# delete no need rules
	rm -f ${D}${base_libdir}/udev/rules.d/50-firmware.rules
	rm -f ${D}${base_libdir}/udev/rules.d/60-block.rules
	rm -f ${D}${base_libdir}/udev/rules.d/60-cdrom_id.rules
	rm -f ${D}${base_libdir}/udev/rules.d/60-drm.rules
	rm -f ${D}${base_libdir}/udev/rules.d/60-evdev.rules
	rm -f ${D}${base_libdir}/udev/rules.d/60-persistent-alsa.rules
	rm -f ${D}${base_libdir}/udev/rules.d/60-persistent-input.rules
	rm -f ${D}${base_libdir}/udev/rules.d/60-persistent-storage-tape.rules
	rm -f ${D}${base_libdir}/udev/rules.d/60-persistent-v4l.rules
	rm -f ${D}${base_libdir}/udev/rules.d/60-serial.rules
	rm -f ${D}${base_libdir}/udev/rules.d/64-btrfs.rules
	rm -f ${D}${base_libdir}/udev/rules.d/70-mouse.rules
	rm -f ${D}${base_libdir}/udev/rules.d/70-power-switch.rules
	rm -f ${D}${base_libdir}/udev/rules.d/70-uaccess.rules
	rm -f ${D}${base_libdir}/udev/rules.d/71-seat.rules
	rm -f ${D}${base_libdir}/udev/rules.d/73-seat-late.rules
	rm -f ${D}${base_libdir}/udev/rules.d/75-net-description.rules
	rm -f ${D}${base_libdir}/udev/rules.d/75-probe_mtd.rules
	rm -f ${D}${base_libdir}/udev/rules.d/78-sound-card.rules
	rm -f ${D}${base_libdir}/udev/rules.d/80-net-setup-link.rules
	rm -f ${D}${base_libdir}/udev/rules.d/90-vconsole.rules

# delete no need service files
	rm -f ${D}${systemd_unitdir}/system/smartcard.target
	rm -f ${D}${systemd_unitdir}/system/systemd-sysusers.service
	rm -f ${D}${systemd_unitdir}/system/systemd-time-wait-sync.service
	rm -f ${D}${systemd_unitdir}/system/systemd-localed.service

# To avoid mount /proc error msg, systemd (>=247), older kernel (<5.8)
	sed -i "s/^\(ProtectProc=*\)/#\1/g"  ${D}${systemd_unitdir}/system/systemd-*.service
}


RRECOMMENDS:${PN} += "util-linux-mkfs e2fsprogs-mke2fs"
RRECOMMENDS:${PN}:remove = "udev-hwdb ${PN}-extra-utils"
RRECOMMENDS:udev := "udev-extraconf"

FILES:${PN} += " \
	${bindir}/format-filesystem.sh \
	${bindir}/format-data-partition.sh \
"
