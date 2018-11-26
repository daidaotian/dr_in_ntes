#!/bin/bash

Usage()
{
cat <<-EOF
    Usage: $0 -d path_to_disk -m mnt_point -u user -g group -t [ext4|xfs] -o mnt_options
    Default:
        -m /srv/nbs/\$n
        -u root
        -g root
        -t ext4
        -o noatime
EOF
# Usage exit 1
    exit 1
}

checkDisk()
{
    ret=1
    while read Disk
    do
        if [[ $(ls ${Disk}* | wc -l) -ne 1 ]];then
            continue
        fi
        if df | grep -qw ${Disk};then
            continue
        fi
        echo $Disk
        ret=0
    done < <(sudo fdisk -l 2>/dev/null | awk '/^Disk.*(G|T)/{sub(":","",$2);print $2}')
    return $ret
}

while getopts "d:m:u:g:t:o:" opt
do
    case $opt in
        d)
            disk=$OPTARG
            ;;
        m)
            mnt_point=$OPTARG
            ;;
        u)
            user=$OPTARG
            ;;
        g)
            group=$OPTARG
            ;;
        t)
            fs_type=$OPTARG
            ;;
        o)
            mnt_options=$OPTARG
            ;;
        *)
            Usage
            ;;
    esac
done

[[ -z "$disk" ]] && Usage
disk=$(readlink -f $disk)
# no disk available exit 2
checkDisk | grep -qw "$disk" || { echo "disk $disk not available.";exit 2; }
if [[ -z "$mnt_point" ]];then
    if [ -d /srv/nbs ];then
        i=$(ls -ld /srv/nbs/[0-9]* | sort -rn | head -1)
        i=${i##*/}
        ((i++))
    else
        i=0
    fi
    mnt_point="/srv/nbs/$i"
fi
user=${user:-appops}
group=${group:-netease}

fs_type=${fs_type:-ext4}
# only support ext4 or xfs
[[ "$fs_type" = "ext4" || "$fs_type" = "xfs" ]] || Usage

mnt_options=${mnt_options:-noatime}
[[ "$mnt_options" =~ ^[a-z0-9,]+$ ]] || { echo "mnt_options error"; Usage; }

# mount point error exit 3
df 2>/dev/null | grep -w "$mnt_point" && { echo "$mnt is already mounted." ;exit 3; }

# parted not found exit 4
sudo which parted &>/dev/null || { echo "command parted not found";exit 4; }

# user not exists exit 5
grep -qw $user /etc/passwd || { echo "user $user is not exists."; exit 5; }

# group not exists exit 6
grep -qw $group /etc/group || { echo "group $group is not exists."; exit 6; }

# mkfs type not found exit 7
mkfs_cmd=mkfs.${fs_type}
sudo which $mkfs_cmd &>/dev/null || { echo "command ${mkfs_cmd} not found";exit 7; }

# now begin to init disk
sudo parted -s $disk -- mklabel gpt mkpart primary 1 -1
c=5
while [[ $c -gt 0 ]]
do
    [ -f ${disk}1 ] && break
    ((c--))
    sleep 1
done
if [[ "$fs_type" = "ext4" ]];then
    sudo $mkfs_cmd ${disk}1 &>/dev/null
elif [[ "$fs_type" = "xfs" ]];then
    sudo $mkfs_cmd -f ${disk}1 &>/dev/null
else
    :
fi
sleep 5
sudo blkid ${disk}1 | awk -v mnt="$mnt_point" -v opts="$mnt_options" -F '"' '{printf "UUID="$2"\t%s\t"$4"\t%s 0 0\n",mnt,opts}' | sudo tee -a /etc/fstab
sudo mkdir -p $mnt_point
sudo mount -a
[[ $(hostname -f) =~ ^.*(yunxin|nim).*.163.org$ ]] && sudo chmod 777 $mnt_point -R

sudo chown $user.$group $mnt_point
