# Summary

zfSnap is a simple sh script to make rolling zfs snapshots with cron. The main
advantage of zfSnap is it's written in 100% pure _/bin/sh_ so it doesn't
require any additional software to run.

zfSnap keeps all information about snapshot in snapshot name.

zfs snapshot names are in the format of **Timestamp--TimeToLive**.

**Timestamp** includes the date and time when the snapshot was created and
**TimeToLive (TTL)** is the amount of time for the snapshot to stay alive
before it's ready for deletion.



## Description of Name Format

**Timestamp** is saved as **year-month-day_hour.minute.second**

  * Example: **2010-08-02_18.45.00**

**TimeToLive** can contain numbers and modifiers and is calculated in seconds

  * Example 1: **1y6m5d2h** - One year, six months, five days, and two hours
  * Example 2: **2m** - Two months
  * Example 3: **216000s** - Two hundred and sixteen thousand seconds (~2 months)
  * Example 4: **216000** - Two hundred and sixteen thousand seconds (the s for seconds is optional)




## Valid TTL Modifiers

  * **y** - years (equals 365 days)
  * **m** - months (equals 30 days)
  * **w** - weeks (equals 7 days)
  * **d** - days
  * **h** - hours
  * **M** - minutes
  * **s** - seconds

**NOTE:** You don't need to include all of these if you are not using them, but
modifiers must be used in this ordering.



# Command line options

**zfSnap** [ _generic options_ ] \[\[ -a _ttl_ ] [ -r|-R ] _zpool/zfs1_ ... ] ...




## Generic options

  * **-d** - deletes snapshots older than the TTL in the snapshot name
  * **-e** - Return exit code return number of failed actions
  * **-F _age_** - Force delete all snapshots older than _**age**_
  * **-o** - Use old timestamp format (**yyyy-mm-dd_hh:mm:ss--ttl**) instead of new (**yyyy-mm-dd_hh.mm.ss--ttl**) (for compatibility with snapshots created before zfSnap v1.4.0)
  * **-s** - Don't do anything on pools running resilver
  * **-S** - Don't do anything on pools running scrub
  * **-z** - round down seconds in the snapshot name to 00 (such as 18:06:15 to 18:06:00)
  * **-n** - perform a test run with no changes made
  * **-v** - verbose output
  * **-zpool28fix** - Workaround for zpool v28 zfs destroy -r bug (More info below)

**NOTE:** Generic options must be specified at beginning of command line



## Options

  * **-a _TTL_** - change default **TTL** (if TTL doesn't match TTL pattern, results may vary). Default TTL is 1m
  * **-r** - create **recursive** snapshots for all zfs file systems that follow this switch
  * **-R** - create **non-recursive** snapshots for all zfs file systems that follow this switch
  * **-p _prefix_** - use **prefix** for snapshots after this switch
  * **-P** - **don't use prefix** for snapshots
  * **-D _zpool/dataset_** - delete all zfSnap snapshots of the specified _**zpool/dataset**_ (Ignores TTL)




# Using zfSnap with /etc/crontab

zfSnap was designed to work with ''/etc/crontab''



## Examples of Rolling Snapshots Using Crontab

Hourly recursive snapshots of an entire pool kept for 5 days

	# Minute   Hour   Day of month   Month   Day of week   Who    Command
	5          *      *              *       *             root   /usr/local/sbin/zfSnap -a 5d -r zpool



Snapshots created at 6:45 and 18:45 kept for 2 weeks of different datasets in
different zpools

	45      6,18    *       *       *       root    /usr/local/sbin/zfSnap -a 2w zpool2/git zpool2/jails zpool2/templates -r zpool2/jails/main zpool2/jails/share1 zpool1/local zpool1/var


**NOTE:** You can use **-a**, **-r** and **-R** as much as you want in a single
line

At 2:15 on the first of every month do

  * zpool/var recursive and hold it for 1 year
  * zpool/home and hold it for 6 minutes
  * zpool/usr and hold it for 3 months
  * zpool/root non-recursive and hold it for 3 months

The magic entry
	15      2    1       *       *       root    /usr/local/sbin/zfSnap -a 1y -r zpool/var -a 6M zpool/home -a 3m zpool/usr -R zpool/root




## Delete old snapshots

It is probably better to delete old snapshots once a day (at least on servers),
then adding **-d** switch to every crontab entry.

This is because deleting zfs snapshots is slower than creating them. Also who
cares if few snapshots stay few hours longer?



This crontab entry will delete old zfs snapshots at 1:00

	# Minute   Hour   Day of month   Month   Day of week   Who    Command
	0          1      *              *       *             root   /usr/local/sbin/zfSnap -d



## Delete old snapshots with old timestamp format

	# Minute   Hour   Day of month   Month   Day of week   Who    Command
	0          1      *              *       *             root   /usr/local/sbin/zfSnap -d -o

Note that this only deletes snapshots with old timestamp format. If you need to
delete snapshots with new timestamp format, you need to add another cron job
(without **-o** flag)



## Delete old snapshots with prefixes

If you are creating snapshots with prefix (**-p** flag) and want to delete
these snapshots (**-d**), then you need to run **zfSnap -d** and specify all
prefixes with **-p** flags.

For example:

if you have create snapshots with *test\_* and *test\_me\_* prefixes simply
running

	# zfSnap -d

won't delete these snapshots.

What you need to run is

	# zfSnap -d -p test_ -p test_me

This will delete all old snapshots without prefix, and snapshots with *text\_*
and *test\_me\_* prefixes



## Delete all zfSnap snapshots on specific filesystem

Since zfSnap v1.5.0 you can delete all zfSnap snapshots on specific filsystems



For example you make recursive zfSnap snapshots of your entire zpool,

but you don't want to keep snapshots of /tmp and /var/tmp,

because they obviously eat up space.



For this you can

	# zfSnap -D zpool/tmp -D zpool/var/tmp

this will delete all zfSnap snapshots of zpool/tmp and zpool/var/tmp ignoring
ttl



**NOTE:** -D option will only delete snapshots that match zfSnap snapshot name
pattern (either old version, or new one)



You can also delete all zfSnap snapshots of specific filesytem recursively.

For example:

	# zfSnap -r -D zpool/var

Will delete all zfSnap snapshots of zpool/var and all it's sub-filesystems



### Using zfSnap with periodic scripts

To use zfSnap periodic scripts you need to edit ''/etc/crontab''



For **hourly** and **reboot** scripts to work you need to add these lines to
your ''/etc/crontab''

	4        *       *       *       *       root    periodic hourly
	@reboot                                  root    periodic reboot

#### Create snapshots

Possible values: YES|NO

  * **hourly_zfsnap_enable**
  * **daily_zfsnap_enable**
  * **weekly_zfsnap_enable**
  * **monthly_zfsnap_enable**
  * **reboot_zfsnap_enable**



#### Pass generic flags to zfSnap.

You should not pass **-v** and **-d** flags.

  * **hourly_zfsnap_flags**
  * **daily_zfsnap_flags**
  * **weekly_zfsnap_flags**
  * **monthly_zfsnap_flags**
  * **reboot_zfsnap_flags**
  * **daily_zfsnap_delete_flags**
  * **weekly_zfsnap_delete_flags**
  * **monthly_zfsnap_delete_flags**



#### Non-recursive snapshots

List of zfs filesystems to create non-recursive snapshots

  * **hourly_zfsnap_fs**
  * **daily_zfsnap_fs**
  * **weekly_zfsnap_fs**
  * **monthly_zfsnap_fs**
  * **reboot_zfsnap_fs**



#### Recursive snapshots

List of zfs filesystems to create recursive snapshots

  * **hourly_zfsnap_recursive_fs**
  * **daily_zfsnap_recursive_fs**
  * **weekly_zfsnap_recursive_fs**
  * **monthly_zfsnap_recursive_fs**
  * **reboot_zfsnap_recursive_fs**



#### Verbose output

Possible values: YES|NO

  * **hourly_zfsnap_verbose**
  * **daily_zfsnap_verbose**
  * **weekly_zfsnap_verbose**
  * **monthly_zfsnap_verbose**
  * **reboot_zfsnap_verbose**
  * **daily_zfsnap_delete_verbose**
  * **weekly_zfsnap_delete_verbose**
  * **monthly_zfsnap_delete_verbose**



#### Set prefix

Create snapshots with prefix (by default prefix will be "hourly-", "daily-",
"weekly-", "monthly-" or "reboot-")

  * **hourly_zfsnap_enable_prefix**
  * **daily_zfsnap_enable_prefix**
  * **weekly_zfsnap_enable_prefix**
  * **monthly_zfsnap_enable_prefix**
  * **reboot_zfsnap_enable_prefix**



#### Override default prefix

  * **hourly_zfsnap_prefix**
  * **daily_zfsnap_prefix**
  * **weekly_zfsnap_prefix**
  * **monthly_zfsnap_prefix**
  * **reboot_zfsnap_prefix**



#### Override default Time To Live

By default ttl for hourly snapshots = 3d, for daily and reboot = 1w, for weekly
= 1m, for monthly = 6m

  * **hourly_zfsnap_ttl**
  * **daily_zfsnap_ttl**
  * **weekly_zfsnap_ttl**
  * **monthly_zfsnap_ttl**
  * **reboot_zfsnap_ttl**



#### Old snapshot deletion

Possible values: YES|NO

  * **daily_zfsnap_delete_enable**
  * **weekly_zfsnap_delete_enable**
  * **monthly_zfsnap_delete_enable**



#### Delete old snapshots with prefixes

Prefixes should be separated with space.

Deletion of old snapshots with "hourly-", "daily-", "weekly-", "monthly-" and
"reboot-" prefixes is hard-coded.

  * **daily_zfsnap_delete_prefixes**
  * **weekly_zfsnap_delete_prefixes**
  * **monthly_zfsnap_delete_prefixes**


#### Example periodic.conf

	hourly_zfsnap_enable="YES"
	hourly_zfsnap_recursive_fs="zpool/root zpool/home"
	hourly_zfsnap_verbose="YES"
	hourly_zfsnap_flags="-s -S"

	reboot_zfsnap_enable="YES"
	reboot_zfsnap_recursive_fs="zpool/root zpool/home"
	reboot_zfsnap_verbose="YES"
	reboot_zfsnap_flags="-s -S"

	daily_zfsnap_delete_enable="YES"
	daily_zfsnap_delete_flags="-s -S"
	daily_zfsnap_delete_verbose="YES"

#### Sample snapshot names

	$ zfs list -t snapshot | grep var
	zpool/var@2010-08-02_12.06.00--1d           8,57M      -   242M  -
	zpool/var@2010-08-02_13.06.00--1d           7,31M      -   243M  -
	zpool/var@2010-08-02_14.06.00--1d           7,43M      -   243M  -
	zpool/var@2010-08-02_15.06.00--1d           7,56M      -   243M  -
	zpool/var@2010-08-02_16.06.00--1d           7,31M      -   243M  -
	zpool/var@2010-08-02_17.06.00--1d           7,18M      -   243M  -
	zpool/var@2010-08-02_18.45.00--1m           5,08M      -   247M  -
	zpool/var@2010-08-02_19.06.00--1d           1,09M      -   243M  -
	zpool/var@2010-08-02_20.06.00--1d           1,37M      -   243M  -
	zpool/var@2010-08-02_21.06.00--1d           1,62M      -   243M  -
	zpool/var@2010-08-02_22.06.00--1d           1,57M      -   243M  -
	zpool/var@2010-08-02_23.06.00--1d           1,16M      -   243M  -
	zpool/var@2010-08-03_00.06.00--5d           1,28M      -   243M  -
	zpool/var@2010-08-03_01.06.00--5d           1,07M      -   243M  -
	zpool/var@2010-08-03_02.06.00--5d            922K      -   243M  -
	zpool/var@2010-08-03_03.06.00--5d           1,45M      -   242M  -
	zpool/var@2010-08-03_04.06.00--5d            729K      -   242M  -
	zpool/var@2010-08-03_05.06.00--5d            622K      -   241M  -
	zpool/var@2010-08-03_06.06.00--5d            598K      -   241M  -
	zpool/var@2010-08-03_06.45.00--2w           1,34M      -   242M  -
	zpool/var@2010-08-03_07.06.00--5d            662K      -   242M  -
	zpool/var@2010-08-03_08.06.00--5d            847K      -   242M  -
	zpool/var@2010-08-03_09.06.00--5d            837K      -   242M  -
	zpool/var@2010-08-03_10.06.00--5d           1,08M      -   242M  -
	zpool/var@2010-08-03_11.06.00--5d           1,22M      -   243M  -
	zpool/var@2010-08-03_12.06.00--5d            241K      -   243M  -


# Supported OS

## FreeBSD port

zfSnap was developed on FreeBSD, therefore zfSnap works best on FreeBSD :)

[[http://www.freshports.org/sysutils/zfsnap/]]

## NetBSD

There are plans to make a NetBSD port for zfSnap, but probably not until NetBSD
officially supports zfs.

## GNU/Linux

zfSnap might work on GNU/Linux out of the box, but it hasn't been tested
because zfs on Linux hasn't matured.

Please let me know if you've tried zfSnap on GNU/Linux (details below)



## Solaris/OpenSolaris?

Starting with zfSnap v1.10.0 from solarislike branch, zfSnap was tested to work
out of the box on:

  * Solaris 11 Express
  * OpenIndiana build 148



## Solaris 10

zfSnap v1.10.0 from solarislike branch was tested to work on Solaris 10, but
GNU tools (grep, sed, date, ...) must be installed and **PATH** environment set
in such way, that GNU tools would be used instead of Solaris 10 default tools.


Also you need to patch zfSnap **#!/bin/sh** to **#!/bin/ksh** or
**#!/usr/local/bin/bash** (or wherever bash 4 or newer is installed. Bash 3
won't work)

There are absolutely no plans to make zfSnap work with Solaris 10 native tools.
These tools are way too crappy, to say the least. Modifying zfSnap to work with
them, would make zfSnap even more harder to read.


## OpenSolaris 2009.06

zfSnap v1.10.0 from solarislike branch was tested to work on OpenSolaris
2009.06, but you must make sure, that **PATH** environment is set in such way,
that GNU tools (grep, sed, date, ...) are used, instead of native tools.


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
