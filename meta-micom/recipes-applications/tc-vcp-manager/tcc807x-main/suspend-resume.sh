#!/bin/bash
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

		# 5. suspend audio
		pactl suspend-source tcsource 1
		pactl suspend-sink tcsink 1
		;;
	resume)
		# 1. resume audio
		pactl suspend-source tcsource 0
		pactl suspend-sink tcsink 0

		# 2. HUD resume
		if [ -e $HUD_SERVICE ]; then
			systemctl start tc-hud-app.service
		fi

		# 3. send resume-dbus to Mode Manager
		/usr/bin/dbus-send --system --type=method_call --dest='telechips.mode.manager' /telechips/mode/manager mode.manager.resume
		sleep 0.1

		# 4. Vbus On,
		if [ -e $REMOVABLE_DISK ]; then
			$REMOVABLE_DISK start
		else
			echo "Can not find $REMOVABLE_DISK"
		fi

		# 5. insmod sdmmc
		modprobe sdhci_tcc_mod

		;;

	*)  exit $NA
		;;
esac
