#
# Regular cron jobs for the zfsnap package
#
0 4	* * *	root	[ -x /usr/bin/zfsnap_maintenance ] && /usr/bin/zfsnap_maintenance
