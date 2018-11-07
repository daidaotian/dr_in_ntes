#!/usr/bin/python
# -*- coding: UTF-8 -*-

# 
import commands
import sys

if len(sys.argv)<=2:
	data = sys.argv[1:]
	while line=sys.stdin.read():
		print(line)
		print(-------)
else:
	print("useage1: \tPython %s file_name"%sys.argv[0])
	print("\t echo "xxx" | %s"%sys.argv[0])
