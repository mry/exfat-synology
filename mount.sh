#!/bin/sh

USB=$(echo "$@" | grep "volumeUSB")
#usb types
if [ -n "$USB" ]; then
    USBSYNC="/bin/usbsync.sh"
    #exfat partition
    if [ "$2" == "exfat" ]; then
        m=$(/bin/mount.bin | grep "$5")
        if [ -z "$m" ]; then
            n="$6"
            # del */volumeUSB*/
            n=${n#*/volumeUSB*/}
            
            #n=${n#*/volumeUSB}
            #n=${n%%/usbshare}
            ##first, get samba shared folder by default
            #MOUNTDIR=$(cat /etc/samba/smb.share.conf | grep 'path=' | grep 'usbexfat')
            #if [ -n "$MOUNTDIR" ]; then
            #    MOUNTDIR=${MOUNTDIR#*=}
            #else
            #    #second, get any dir named: usbexft
            #    MOUNTDIR=$(find /volume*/usbexfat -name 'usbexfat' -type d | sed -n '1p')
            #    if [ -z "$MOUNTDIR" ]; then
            #        #third, get the first volume and create dir usbexfat
            #        MOUNTDIR=$(find /volume* -type d | sed -n '1p')"/usbexfat"
            #    fi                
            #fi
            #MOUNTPOINT="$MOUNTDIR/usbshare$n"
            MOUNTPOINT="/volume1/usbexfat/$n"
            if [ ! -d "$MOUNTPOINT" ]; then
                mkdir -p "$MOUNTPOINT"
            fi
            /bin/mount.exfat-fuse "$5" "$MOUNTPOINT" -o nonempty
            if [ -f "$USBSYNC" ]; then
                "$USBSYNC" "$5" "$MOUNTPOINT" &
            fi
        fi
    #fat32 partition
    elif [ "$2" == "vfat" ]; then
        /bin/mount.bin "$@" &
        if [ -f "$USBSYNC" ]; then
            "$USBSYNC" "$5" "$6" &
        fi
    #others partition
    else
        /bin/mount.bin "$@"      
    fi
#other types
else
    /bin/mount.bin "$@"
fi
