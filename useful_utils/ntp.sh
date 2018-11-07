#!/bin/bash

echo ==ntp
nocheck=0
offset=0
sync=1 #critical
if [[ -e /etc/openntpd/ntpd.conf ]];then
	sync=0
	offset=0
elif [[ -e /usr/sbin/ntpq ]];then
    output=`/usr/sbin/ntpq -np 127.0.0.1 |grep -v '127.127.1.0'  |/bin/grep -e "^*"`
    if [ $? -eq 0 ];then
        sync=0
        offset=`echo "$output" | awk '{print $9}'`
        offset=${offset/-/}
    else
        offset=`/usr/sbin/ntpdate -q 223.252.222.4 | awk '/ntpdate/{print$(NF-1)}'`
    fi
elif [[ -e /usr/sbin/ntpdc ]];then
    output=`/usr/sbin/ntpdc -np 127.0.0.1 |grep -v '127.127.1.0'  |/bin/grep -e "^*"`
    if [ $? -eq 0 ];then
        sync=0
        offset=`echo "$output" | awk '{print $7}'`
        offset=${offset/-/}
    else
        offset=`/usr/sbin/ntpdate -q 223.252.222.4 | awk '/ntpdate/{print$(NF-1)}'`
    fi
elif [[ -e /usr/bin/ntpq ]];then
    output=`/usr/bin/ntpq -np 127.0.0.1 |grep -v '127.127.1.0'  |/bin/grep -e "^*"`
    if [ $? -eq 0 ];then
        sync=0
        offset=`echo "$output" | awk '{print $9}'`
        offset=${offset/-/}
    else
        offset=`/usr/sbin/ntpdate -q 223.252.222.4 | awk '/ntpdate/{print$(NF-1)}'`
    fi
elif [[ -e /usr/bin/ntpdc ]];then
    output=`/usr/bin/ntpdc -np 127.0.0.1 |grep -v '127.127.1.0'  |/bin/grep -e "^*"`
    if [ $? -eq 0 ];then
        sync=0
        offset=`echo "$output" | awk '{print $7}'`
        offset=${offset/-/}
    else
        offset=`/usr/sbin/ntpdate -q 223.252.222.4 | awk '/ntpdate/{print$(NF-1)}'`
    fi
else
    sync=1
    offset=`/usr/sbin/ntpdate -q 223.252.222.4 | awk '/ntpdate/{print$(NF-1)}'`
fi
echo -e  "sync=$sync,offset=$offset"
exit 0