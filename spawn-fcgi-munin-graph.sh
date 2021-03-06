#!/bin/sh

### BEGIN INIT INFO
# Provides:          spawn-fcgi-munin-graph
# Required-Start:    $local_fs $remote_fs $network $syslog
# Required-Stop:     $local_fs $remote_fs $network $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: spawns the munin-graph fastcgi processes
# Description:       spawns fastcgi using start-stop-daemon
### END INIT INFO

# spawn-fcgi -s /var/run/munin/munin-fastcgi-html.sock -U www-data -u munin -g munin /usr/lib/cgi-bin/munin-cgi-graph
#set -x -v

USER=munin
USER_SOCKET=www-data
GROUP=munin
PATH=/sbin:/bin:/usr/sbin:/usr/bin
SCRIPTNAME=/etc/init.d/spawn-fcgi-munin-graph
SSD="/sbin/start-stop-daemon" 
RETVAL=0

FCGI_DAEMON="/usr/bin/spawn-fcgi" 
FCGI_PROGRAM="/usr/lib/cgi-bin/munin-cgi-graph" 
FCGI_PORT="4050" 
FCGI_SOCKET="/var/run/munin/munin-fastcgi-graph.sock" 
FCGI_PIDFILE="/var/run/spawn-fcgi-munin-graph.pid" 

set -e

export FCGI_WEB_SERVER_ADDRS

. /lib/lsb/init-functions

case "$1" in
  start)
        log_daemon_msg "Starting spawn-fcgi" 
        if ! $FCGI_DAEMON -s $FCGI_SOCKET -f $FCGI_PROGRAM -u $USER -U $USER_SOCKET -g $GROUP -P $FCGI_PIDFILE; then
            log_end_msg 1
        else
            log_end_msg 0
        fi
        RETVAL=$?
  ;;
  stop)
        log_daemon_msg "Killing all spawn-fcgi processes" 
        if killall --signal 2 php-cgi > /dev/null 2> /dev/null; then
            log_end_msg 0
        else
            log_end_msg 1
        fi
        RETVAL=$?
  ;;
  restart|force-reload)
        $0 stop
        $0 start
  ;;
  *)
        echo "Usage: $SCRIPTNAME {start|stop|restart|reload|force-reload}" >&2
        exit 1
  ;;
esac

exit $RETVAL
