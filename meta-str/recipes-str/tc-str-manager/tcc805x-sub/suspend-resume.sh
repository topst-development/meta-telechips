#!/bin/bash
SUSPEND_RVC="/usr/bin/suspend-rvc.sh"
SUSPEND_MICOM_MAN="/usr/bin/suspend-micom-manager.sh"

case $1 in
	suspend)
		# 1. RVC suspend
		if [ -e $SUSPEND_RVC ]; then
			$SUSPEND_RVC suspend
		fi

		# 2. micom-manager suspend
		if [ -e $SUSPEND_MICOM_MAN ]; then
			$SUSPEND_MICOM_MAN suspend
		fi

		;;
	resume)
		# 1. micom-manager resume
		if [ -e $SUSPEND_MICOM_MAN ]; then
			$SUSPEND_MICOM_MAN resume
		fi

		# 2. RVC resume
		if [ -e $SUSPEND_RVC ]; then
			$SUSPEND_RVC resume
		fi
		;;

	*)  exit $NA
		;;
esac
