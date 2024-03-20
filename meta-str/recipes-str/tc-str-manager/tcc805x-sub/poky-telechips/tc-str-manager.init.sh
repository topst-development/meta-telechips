#! /bin/sh
### BEGIN INIT INFO
# Provides:             Telechips STR Manager
# Required-Start:    
# Required-Stop:     
# Default-Start:        2 5
# Default-Stop:         0
# Short-Description:    Telechips STR Manager
### END INIT INFO

# Source function library.
. /etc/init.d/functions

# /etc/init.d/tc-str-manager: start and stop the tc-str-manager daemon

DAEMON=/usr/bin/TCSTRManager
DESC="telechips str manager"
ARGUMENTS="-d 1 -t sub"

test -x $DAEMON || exit 0

[ -z "$SYSCONFDIR" ] && SYSCONFDIR=/var/lib/tc-str-manager
mkdir -p $SYSCONFDIR

case "$1" in
  start)
  	echo -n "Starting $DESC: "
	$DAEMON $ARGUMENTS &
  	echo "done."
	;;
  stop)
  	echo -n "Stopping $DESC: "
	/usr/bin/killall -9 TCSTRManager
  	echo "done."
	;;

  restart)
  	echo -n "Restarting $DESC: "
	/usr/bin/killall -9 TCSTRManager
	sleep 0.5
	$DAEMON $ARGUMENTS
	echo "."
	;;

  status)
	status $DAEMON
	exit $?
  ;;

  *)
	echo "Usage: /etc/init.d/tc-str-manager {start|stop|status|restart}"
	exit 1
esac

exit 0
