#!/bin/bash
SUSPEND_MICOM_MAN="/usr/bin/suspend-micom-manager.sh"
REMOVABLE_DISK="/usr/bin/enable-removable-disk.sh"
HUD_SERVICE="/lib/systemd/system/tc-hud-app.service"

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

		# 3. Send suspend-dbus to Mode Manager
		/usr/bin/dbus-send --system --type=method_call --dest='telechips.mode.manager' /telechips/mode/manager mode.manager.suspend
		sleep 0.1
		# 4. hud suspend
		if [ -e $HUD_SERVICE ]; then
			systemctl stop tc-hud-app.service
		fi

		# 5. micom-manager suspend
		if [ -e $SUSPEND_MICOM_MAN ]; then
			$SUSPEND_MICOM_MAN suspend
		else
			echo "Can not find  $SUSPEND_MICOM_MAN"
		fi

		# 6. suspend audio
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
		else
			echo "Can not find  $SUSPEND_MICOM_MAN"
		fi

		# 3. HUD resume
		if [ -e $HUD_SERVICE ]; then
			systemctl start tc-hud-app.service
		fi

		# 4. send resume-dbus to Mode Manager
		/usr/bin/dbus-send --system --type=method_call --dest='telechips.mode.manager' /telechips/mode/manager mode.manager.resume
		sleep 0.1

		# 5. Vbus On,
		if [ -e $REMOVABLE_DISK ]; then
			$REMOVABLE_DISK start
		else
			echo "Can not find $REMOVABLE_DISK"
		fi

		# 6. insmod sdmmc
		modprobe sdhci_tcc_mod

		;;

	*)  exit $NA
		;;
esac
