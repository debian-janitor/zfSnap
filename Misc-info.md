# Misc info

## zpool v28 zfs destroy -r bug

If you updated your zpool to v28, then you might get hit with zfs destroy -r
bug (regression?). This bug prevents deleting snapshots recursively if you
don't have snapshot on filesystem from which you recursively try to delete
snapshots.

For example, you have **tank/b@snapshot**, but don't have **tank@snapshot**,
then

	zfs destroy -r tank@snapshot

won't work as it used to be (won't delete any snapshots). Using **-zpool28fix**
workaround zfSnap will delete every snapshot (that zfSnap would normally
delete) one by one. Deleting snapshots will be slower, but at least it will
work.

This problem also persists on _OpenIndiana dev-148_ with zpool v28, however on
_Oracle Solaris 11 Express 2010.11_ with zpool v31 the problem is gone.


You can check version of zpool by running

	zpool get version tank

If your zpool is at v15 or v14, then you don't need to use **-zpool28fix**


Some related mails on mailinglist:

  * <http://www.freebsd.org/cgi/getmsg.cgi?fetch=26590+30792+/usr/local/www/db/text/2011/freebsd-fs/20110327.freebsd-fs>
  * <http://www.freebsd.org/cgi/getmsg.cgi?fetch=326330+329407+/usr/local/www/db/text/2011/freebsd-fs/20110508.freebsd-fs>
  * <http://www.freebsd.org/cgi/getmsg.cgi?fetch=392420+397429+/usr/local/www/db/text/2011/freebsd-current/20110327.freebsd-current>
  * <http://www.freebsd.org/cgi/getmsg.cgi?fetch=63397+70918+/usr/local/www/db/text/2011/freebsd-current/20110320.freebsd-current>
  * <http://www.freebsd.org/cgi/getmsg.cgi?fetch=52098+59772+/usr/local/www/db/text/2011/freebsd-current/20110320.freebsd-current>



## License

zfSnap is licensed with BEER-WARE license

	# "THE BEER-WARE LICENSE":
	# <aldis@bsdroot.lv> wrote this file. As long as you retain this notice you
	# can do whatever you want with this stuff. If we meet some day, and you think
	# this stuff is worth it, you can buy me a beer in return Aldis Berjoza


## Name

zfs + snap => zfssnap => zfSnap



## Versions

Major.Minor.Fix

  * Major - Changes when new version is incompatible with previous version
  * Minor - Some new features are added
  * Fix - changed frequently :)



## Source repository

zfSnap git repository <https://github.com/graudeejs/zfSnap>



## Report bugs

<https://github.com/graudeejs/zfSnap/issues>



## Feedback

If you like **zfSnap** send me a feedback <zfsnap@bsdroot.lv> (In English,
Latvian or Russian languages)
