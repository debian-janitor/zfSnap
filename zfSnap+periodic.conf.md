# Using zfSnap with periodic scripts

To use zfSnap periodic scripts you need to edit ''/etc/crontab''


For **hourly** and **reboot** scripts to work you need to add these lines to
your ''/etc/crontab''

	4        *       *       *       *       root    periodic hourly
	@reboot                                  root    periodic reboot

## Create snapshots

Possible values: YES|NO

  * **hourly_zfsnap_enable**
  * **daily_zfsnap_enable**
  * **weekly_zfsnap_enable**
  * **monthly_zfsnap_enable**
  * **reboot_zfsnap_enable**



## Pass generic flags to zfSnap.

You should not pass **-v** and **-d** flags.

  * **hourly_zfsnap_flags**
  * **daily_zfsnap_flags**
  * **weekly_zfsnap_flags**
  * **monthly_zfsnap_flags**
  * **reboot_zfsnap_flags**
  * **daily_zfsnap_delete_flags**
  * **weekly_zfsnap_delete_flags**
  * **monthly_zfsnap_delete_flags**



## Non-recursive snapshots

List of zfs filesystems to create non-recursive snapshots

  * **hourly_zfsnap_fs**
  * **daily_zfsnap_fs**
  * **weekly_zfsnap_fs**
  * **monthly_zfsnap_fs**
  * **reboot_zfsnap_fs**



## Recursive snapshots

List of zfs filesystems to create recursive snapshots

  * **hourly_zfsnap_recursive_fs**
  * **daily_zfsnap_recursive_fs**
  * **weekly_zfsnap_recursive_fs**
  * **monthly_zfsnap_recursive_fs**
  * **reboot_zfsnap_recursive_fs**



## Verbose output

Possible values: YES|NO

  * **hourly_zfsnap_verbose**
  * **daily_zfsnap_verbose**
  * **weekly_zfsnap_verbose**
  * **monthly_zfsnap_verbose**
  * **reboot_zfsnap_verbose**
  * **daily_zfsnap_delete_verbose**
  * **weekly_zfsnap_delete_verbose**
  * **monthly_zfsnap_delete_verbose**



## Set prefix

Create snapshots with prefix (by default prefix will be "hourly-", "daily-",
"weekly-", "monthly-" or "reboot-")

  * **hourly_zfsnap_enable_prefix**
  * **daily_zfsnap_enable_prefix**
  * **weekly_zfsnap_enable_prefix**
  * **monthly_zfsnap_enable_prefix**
  * **reboot_zfsnap_enable_prefix**



## Override default prefix

  * **hourly_zfsnap_prefix**
  * **daily_zfsnap_prefix**
  * **weekly_zfsnap_prefix**
  * **monthly_zfsnap_prefix**
  * **reboot_zfsnap_prefix**



## Override default Time To Live

By default ttl for hourly snapshots = 3d, for daily and reboot = 1w, for weekly
= 1m, for monthly = 6m

  * **hourly_zfsnap_ttl**
  * **daily_zfsnap_ttl**
  * **weekly_zfsnap_ttl**
  * **monthly_zfsnap_ttl**
  * **reboot_zfsnap_ttl**



## Old snapshot deletion

Possible values: YES|NO

  * **daily_zfsnap_delete_enable**
  * **weekly_zfsnap_delete_enable**
  * **monthly_zfsnap_delete_enable**



## Delete old snapshots with prefixes

Prefixes should be separated with space.

Deletion of old snapshots with "hourly-", "daily-", "weekly-", "monthly-" and
"reboot-" prefixes is hard-coded.

  * **daily_zfsnap_delete_prefixes**
  * **weekly_zfsnap_delete_prefixes**
  * **monthly_zfsnap_delete_prefixes**


## Example periodic.conf

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

