# Description
Application to display System Status on I2C OLED display.
This fork hopes to add out-of-the-box support for the ODROID HC4 OLED display.

![system status](capture/luma_000001.png)

* All the credit to [kobol-io/sys-oled](https://github.com/kobol-io/sys-oled)
## INSTALLATION

```
git clone https://github.com/rpardini/sys-oled-hc4.git
cd sys-oled-hc4
sudo ./install.sh
```
### Configure storage info

By default **sys-oled** will display usage info of your micro SDcard which is most probably your Root File System. You can display storage usage info of one more storage device by editing */etc/sys-oled.conf*

```
sudo nano /etc/sys-oled.conf
```

You can edit the following lines to define for which storage devices you want to display usage info.

```
# Storage Device 1
# Device name
storage1_name = sd

# Device mount path
storage1_path = /

# Storage Device 2
storage2_name= md0
storage2_path= /mnt/md0

```

In the above example, we are displaying **sd** (SDcard) usage which is the rootfs mounted on *'/'*. We are also displaying **md0** (RAID array) that is mounted on *'/mnt/mnd0'*.

### Thermal shutdown guard

`install.sh` also installs `drive-temp-guard`, run by cron every 5 minutes. It reads
`drive_devices` and `shutdown_drive_temp` from */etc/sys-oled.conf* and powers the machine
off if any drive is hotter than the threshold. Sleeping drives are never woken.

When that happens a note is written to */var/lib/sys-oled/thermal-shutdown.txt* and shown at
the next login (via */etc/update-motd.d*). Remove the file to clear the notice. Each event is
also appended to */var/log/drive-temp-guard.log* and the journal.

Check the current readings by hand with:

```
sudo drive-temp-guard -v
```
