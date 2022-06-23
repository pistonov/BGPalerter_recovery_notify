# BGPalerter_recovery_notify
Prefixes Re-Announcement Monitoring after has been withdrawn. ([issues #428](https://github.com/nttgin/BGPalerter/issues/428))

Bash script by cron check BGPalerter logs and check withdrawned prefixes.
If the prefix is announced again, then the script sends a notification to the telegram.

Put script to some directory and add task to cron.
```
*/2 * * * * root /bin/bash /home/scripts/BGPalerter_recovery_notify.sh >/dev/null 2>/dev/null
```
