# BGPalerter_recovery_notify
Prefixes Re-Announcement Monitoring after has been withdrawn. ([issues #428](https://github.com/nttgin/BGPalerter/issues/428))

Bash script by cron check BGPalerter logs and check withdrawned prefixes.

Requires [ripstat](https://github.com/RIPE-NCC/ripestat-text.git) utility to work.
If the prefix is announced again, then the script sends a notification to the telegram.

Put script to some directory and add task to cron.
```
* * * * * root /bin/bash /home/scripts/BGPalerter_recovery_notify.sh >/dev/null 2>/dev/null
```
