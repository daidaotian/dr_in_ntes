#!/usr/bin/python
# -*- coding: UTF-8 -*-

#ssd number:8
#numjobs 1 2 4 8 16 32
#output dir: .

#import commands
import os
import time

#filename_list=['/dev/nvme3n1','/dev/nvme4n1','/dev/nvme5n1','/dev/nvme6n1','/dev/nvme7n1','/dev/nvme8n1','/dev/nvme9n1','/dev/nvme10n1']
#name_list=['huawei','westsn200','intelp4610','intelp4510','meiguang9200pro','meiguang9200max','samsungpm1725b','samsungpm983']
numjobs_list=[1,2,4,8,16,32]

filename_list=['/dev/nvme3n1']
name_list=['huawei']
#output_files=['','','']
#rw_type=['randread ','randwrite ','randrw']

#randread
try:
    for i in range(0,len(filename_list)):
        for j in range(0,6):
            bash_str="fio -filename=%s -direct=1 -iodepth 32 -rw=randread -ioengine=libaio -bs=4k -size=1000G -numjobs=%d -runtime=300  -group_reporting -time_based -ramp_time=30 -name=%s>>randread.txt"%(filename_list[i],numjobs_list[j],name_list[i])
            #commands.getoutput(bash_str).strip()
            os.system(bash_str)
            os.system("echo '###########################'>>randread.txt")
            time.sleep(5)			
except:
    os.system("echo '#XXXXXXXXXXXXXXXXXXXXXXXXXXX'>>randread.txt")
    pass				
#randwrite
try:
    for i in range(0,len(filename_list)):
        for j in range(0,6):
            bash_str="fio -filename=%s -direct=1 -iodepth 32 -rw=randwrite -ioengine=libaio -bs=4k -size=1000G -numjobs=%d -runtime=300  -group_reporting -time_based -ramp_time=30 -name=%s>>randwrite.txt"%(filename_list[i],numjobs_list[j],name_list[i])
            #commands.getoutput(bash_str).strip()
            os.system(bash_str)
            os.system("echo '###########################'>>randwrite.txt")
            time.sleep(5)			
except:
    os.system("echo '#XXXXXXXXXXXXXXXXXXXXXXXXXXX'>>randwrite.txt")
    pass
#randrw
try:
    for i in range(0,len(filename_list)):
        for j in range(0,6):
            bash_str="fio -filename=%s -direct=1 -iodepth 32 -iodepth_batch_complete 16 -rw=randrw -rwmixread=75 -ioengine=libaio -bs=4k -size=1000G -numjobs=%d -runtime=300  -group_reporting -time_based -ramp_time=30 -name=%s>>randrw.txt"%(filename_list[i],numjobs_list[j],name_list[i])
            #commands.getoutput(bash_str).strip()
             os.system(bash_str)
             os.system("echo '###########################'>>randrw.txt")
             time.sleep(5)			
except:
    os.system("echo '#XXXXXXXXXXXXXXXXXXXXXXXXXXX'>>randrw.txt")
    pass
