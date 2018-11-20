"""Import data from lockin memory and send over TCP socket"""
"""Experimental version"""
import socket
import mmap
import numpy as np
import netifaces as ni
import time
import resource
import struct
import subprocess
import select
import codecs
from array import array

# memory location constants
SET_LOC = 0x43C00000 #Memory address of AXI_input in LockIn project
A_X_OFF = 128 #Offset of channel A, X information
A_Y_OFF = 132
A_AMP_OFF = 136
A_PH_OFF = 140
B_X_OFF = 144
B_Y_OFF = 148
B_AMP_OFF = 152
B_PH_OFF = 156
CNT_OFF = 160 #Offset of the sweep counter
START_OFF = 164
END_OFF = 168

DAT_LOC = 0x18000000  #Memory address of data location
DAT_SIZE = 0x00800000  #Size of each individual buffer
A_X_POS = 0 #Position of A_X data (DAT_LOC+A_X_POS*DAT_SIZE)
A_Y_POS = 1
A_AMP_POS = 2
A_PH_POS = 3
B_X_POS = 4
B_Y_POS = 5
B_AMP_POS = 6
B_PH_POS = 7
TOT_DAT = 8 #Total number of data outputs
NUM_BYTES = 4 #Bytes per point


startCode = 1471741
endCode = 1741471

memDev = open("/dev/mem", "r+b")
settingMem = mmap.mmap(memDev.fileno(), resource.getpagesize(), offset=SET_LOC, prot=mmap.PROT_READ)
dataMem = mmap.mmap(memDev.fileno(), TOT_DAT*DAT_SIZE, offset=DAT_LOC, prot=mmap.PROT_READ)


print "%s" % type(dataMem)
print "%s" % len(dataMem)
dataMem.flush()
dataSize = 400

f = open('/media/ramdisk/out.lid','wb')
f.write(dataMem)
	#for i in xrange(1,len(dataMem)):
		#f.write(dataMem[i])
		#if(1 < i < 300):
			#f.write(struct.pack('i', -99999))
f.close();
	

