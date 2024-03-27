#!/bin/bash
SUSPEND_RVC="/usr/bin/suspend-rvc.sh"
REMOVABLE_DISK="/usr/bin/enable-removable-disk.sh"

case $1 in
	suspend)
		# 1. vbus off
		if [ -e $REMOVABLE_DISK ]; then
			$REMOVABLE_DISK stop
			sleep 0.2
		else
			echo "Can not find $REMOVABLE_DISK"
		fi

		# 2. RVC suspend
		if [ -e $SUSPEND_RVC ]; then
			$SUSPEND_RVC suspend
		fi

		;;
	resume)

		# 1. RVC resume
		if [ -e $SUSPEND_RVC ]; then
			$SUSPEND_RVC resume
		fi

		# 2. Vbus On,
		if [ -e $REMOVABLE_DISK ]; then
			$REMOVABLE_DISK start
		else
			echo "Can not find $REMOVABLE_DISK"
		fi

		;;

	*)  exit $NA
		;;
esac
