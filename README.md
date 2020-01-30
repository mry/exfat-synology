#exfat-synology auto mount

> Perfect shell scripts to automatic mount/unmount exfat disk partition on Synology DiskStation NAS (x86 platform).
> Currently support only one exfat partition, and don't try to write data into the exfat partition! Which will have unexpected problems.

**Tested on VitualBox + Jun's Mod V1.02-alpha + DS3615xs + DSM 6.1-15047 Update 1, use this at your own risks.**

##How-To Guide

**Initialize Setup**

**[ 1 ]** Enabled Telnet service on Synology DiskStation, [Control Panel] -> [Terminal & SNMP]: [Enable Telnet service] & [Enable SSH service]; 

**[ 2 ]** SSH to NAS & enable root account;
```
ssh admin@ipaddress

sudo su -
synouser --setpw root your_new_root_password
```

**[ 3 ]** Login NAS via SSH or Telnet, using root account :

for x64 version

```
wget -P /tmp/ http://mirrors.ustc.edu.cn/ubuntu-ports/pool/universe/f/fuse-exfat/exfat-fuse_1.2.3-1_amd64.deb
dpkg -x /tmp/exfat-fuse_1.2.3-1_amd64.deb /tmp/exfat-fuse/
cp /tmp/exfat-fuse/sbin/mount.exfat-fuse /bin/
```

for arm64 version like ds119j,ds120j,catdrive

```
wget -P /tmp/ http://mirrors.ustc.edu.cn/ubuntu-ports/pool/universe/f/fuse-exfat/exfat-fuse_1.2.3-1_arm64.deb
dpkg -x /tmp/exfat-1.2.3-1_arm64_arm64.deb /tmp/exfat-fuse/
cp /tmp/exfat-fuse/sbin/mount.exfat-fuse /bin/
```

**P.S.**

It been tested Synology x86 platform, can directly use ubuntu amd64 version exfat-fuse bin file to mount exfat disk partition.

I also keep exfat-fuse_1.2.3-1_amd64.deb file in my repository.

**[ 4 ]** Go back to Synology DiskStation, [Control Panel] -> [Shared Folder], create a shared folder on volume1, e.g. usbexfat. 

This will create a sub-dir /volume1/usbexfat/usbshare[1...n] will be used as mountpoint, usbshare[1...n] same as the volumeUSB[1...n] mountpoint.

e.g.

volumeUSB1/usbshare will be mapped to /volume1/usbexfat/usbshare1

volumeUSB2/usbshare will be mapped to /volume1/usbexfat/usbshare2

...

volumeUSB[n]/usbshare will be mapped to /volume1/usbexfat/usbshare[n]

**P.S.**

It will automatically check any direction named: usbexfat in the system as the following orders:

1. samba shared folder named: usbexfat;
2. the first volume which does contain the dir name: usbexfat, if not No.1;
3. the first volume which does not contain the dir name: usbexfat, if not No.2.

No matter what, the dir /volume*/usbexfat will be created. If it is not shared, then it stays invisible.

**P.S.**

If your own mountpoint does not look like /volume1/usbexfat/usbshare[1...n], you need to modify mountpoint in the mount.sh!
```
...
MOUNTPOINT="/volume1/usbexfat/usbshare$n"
...
```

**[ 5 ]** Copy the files from this repository, and override some system files
```
wget -P /tmp/ https://github.com/luckylz2git/exfat-synology/raw/master/mount.sh --no-check-certificate
chmod 755 /tmp/mount.sh
mv /bin/mount /bin/mount.bin
mv /tmp/mount.sh /bin/mount

wget -P /tmp/ https://github.com/luckylz2git/exfat-synology/raw/master/synocheckshare.sh --no-check-certificate
chmod 755 /tmp/synocheckshare.sh
mv /usr/syno/bin/synocheckshare /usr/syno/bin/synocheckshare.bin
mv /tmp/synocheckshare.sh /usr/syno/bin/synocheckshare
```

**[ 6 ]** Now the exfat partition can be automatically mount! And also can eject the disk from DiskStation Webpage.

**[ 7 ]** Post-Mount automatically functions 

1. Incremental import for DSLR Photos & Videos, visit: [usbsync](https://github.com/luckylz2git/exfat-synology/tree/master/usbsync).

2. Automatically Rename Photos & Videos, visit: [exifname](https://github.com/luckylz2git/exfat-synology/tree/master/exifname).

##Upgrade

SSH or Telnet:
```
wget -P /tmp/ https://github.com/luckylz2git/exfat-synology/raw/master/upgrade.sh --no-check-certificate
chmod 755 /tmp/upgrade.sh
/tmp/upgrade.sh
```

##Uninstall

SSH or Telnet:
```
if [ -f /usr/syno/bin/synocheckshare.bin ]; then
    rm /usr/syno/bin/synocheckshare
    mv /usr/syno/bin/synocheckshare.bin /usr/syno/bin/synocheckshare
fi
if [ -f /bin/mount.bin ]; then
    rm /bin/mount
    mv /bin/mount.bin /bin/mount
fi
```
