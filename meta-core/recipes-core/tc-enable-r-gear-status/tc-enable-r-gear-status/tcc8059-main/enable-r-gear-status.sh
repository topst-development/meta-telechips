#!/bin/sh
### BEGIN INIT INFO
# Provides:             Telechips Enable R-Gear Status
# Required-Start:
# Required-Stop:
# Default-Start:        5
# Default-Stop:         0
# Short-Description:    Script to enable r-gear status
# Description:          Script to enable r-gear status before booting animation
### END INIT INFO
#
# -*- coding: utf-8 -*-
# Debian init.d script for Telechips Launcher
# Copyright © 2014 Wily Taekhyun Shin <thshin@telechips.com>


case "$1" in
  start)
	. /etc/profile
	echo 168 > /sys/class/gpio/export
	echo "in" > /sys/class/gpio/gpio168/direction
	ln -s /sys/class/gpio/gpio168/value /dev/r_gear_status
	;;
  *)
	echo "Usage: /usr/bin/enable-r-gear-status {start}"
	exit 1
esac

exit 0
