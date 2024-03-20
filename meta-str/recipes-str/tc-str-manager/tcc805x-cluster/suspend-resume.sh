#!/bin/bash
SUSPEND_MICOM_MAN="/usr/bin/suspend-micom-manager.sh"
REMOVABLE_DISK="/usr/bin/enable-removable-disk.sh"

case $1 in
	suspend)
		# 1. vbus off, sdmmc remove
		if [ -e $REMOVABLE_DISK ]; then
			$REMOVABLE_DISK stop
			sleep 0.2
		else
			echo "Can not find $REMOVABLE_DISK"
		fi

		# 2. rmmod sdmmc	
		modprobe -r sdhci_tcc_mod

		# 3. micom-manager suspend
		if [ -e $SUSPEND_MICOM_MAN ]; then
			$SUSPEND_MICOM_MAN suspend
		fi

		# 4. suspend audio
		pactl suspend-source tcsource 1
		pactl suspend-sink tcsink 1
		;;
	resume)
		# 1. resume audio
		pactl suspend-source tcsource 0
		pactl suspend-sink tcsink 0

		# 2. micom-manager resume
		if [ -e $SUSPEND_MICOM_MAN ]; then
			$SUSPEND_MICOM_MAN resume
		fi

		# 3. Vbus On,
		if [ -e $REMOVABLE_DISK ]; then
			$REMOVABLE_DISK start
		else
			echo "Can not find $REMOVABLE_DISK"
		fi

		# 4. insmod sdmmc
		modprobe sdhci_tcc_mod

		;;

	*)  exit $NA
		;;
esac
