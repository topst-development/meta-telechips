#! /bin/sh
### BEGIN INIT INFO
# Provides:             Telechips T-Media Boot Animation Application
# Required-Start:
# Required-Stop:
# Default-Start:        2 5
# Default-Stop:         0
# Short-Description:    Telechips T-Media Framework Booting Application
# Description:          t_media_bootani is a simple booting animation app using tms_mini for Telechips Automotive Linux SDK
### END INIT INFO
#
# -*- coding: utf-8 -*-
# Copyright © 2014 Wily Taekhyun Shin <thshin@telechips.com>

# Source function library.
. /etc/init.d/functions

t_media_bootani=/usr/bin/basic_player_bootani
EXTRA_ARGS="/usr/share/boot-animation.mp4"

DESC="telechips t-media bootani application"

test -x $t_media_bootani || exit 1

[ -r /etc/default/t-media-bootani ] && . "/etc/default/t-media-bootani"

case "$1" in
  start)
	echo -n "Starting $DESC: "
	/sbin/modprobe vpu_4k_d2_lib
	/sbin/modprobe vpu_4k_d2_dev
    start-stop-daemon -S -b -q -x $t_media_bootani -- $EXTRA_ARGS
	echo "done."
	;;
  stop)
	echo -n "Stopping $DESC: "
    start-stop-daemon -K -q -n $t_media_bootani
	echo "done."
	;;
  restart)
	echo -n "Restarting $DESC: "
    start-stop-daemon -K -q -n $t_media_bootani
	sleep 1
    start-stop-daemon -S -b -q -x $t_media_bootani -- $EXTRA_ARGS
	echo "done."
	;;

  status)
	status $t_media_bootani
	exit $?
  ;;

  *)
	echo "Usage: /etc/init.d/t-media-bootani {start|stop|status|restart}"
	exit 1
esac

exit 0
