#!/bin/bash
 
# 修改指定目录的子目录或文件到默认权限
# 下面的函数是递归修改子目录及文件的权限，但是还有一种方法就是复制整个目录，权限会自然就设置成默认的了
function chmodDefault()
{
	if [ -d "$1" ]; then
		chmod 755 "$1"
	fi
 
	for i in $1/*
	do
		if [ -f "$i" ]; then
			chmod 644 "$i"
		elif [ -d "$i" ]; then
			chmod 755 "$i"
			chmodDefault "$i"
		fi
	done
}
 
if [ "$1" = "" ]; then
	echo "Usage: sh $0 <dir>"
else
	chmodDefault "$1"
fi
