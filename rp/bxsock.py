"""Import data from lockin memory and send over TCP socket"""
"""Experimental ENVY type version for single datum streaming"""
import socket
import mmap
import numpy as np
import netifaces as ni
import time
import resource
import struct
import subprocess
import select

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

# get ip address to bind to
ip = ni.ifaddresses('eth0')[2][1]['addr']
print ip 

HOST = ip #"137.205.214.123"
PORT = 1005
PORT2 = 1002

f = open('bxdata.csv', 'w')

# bind to port
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
#s2 = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
#s2.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
print "Sockets Created"
s.bind((HOST, PORT))
#s2.bind((HOST, PORT2))
print "Socket Binds Complete"
s.listen(1)
#s2.listen(1)
print "Sockets now listening"
# message sizes for sending to client
messageSize = 128
#buffer = np.zeros(messageSize, dtype = 'uint32')

startCode = 1471741
endCode = 1741471

memDev = open("/dev/mem", "r+b")
settingMem = mmap.mmap(memDev.fileno(), resource.getpagesize(), offset=SET_LOC, prot=mmap.PROT_READ)
dataMem = mmap.mmap(memDev.fileno(), TOT_DAT*DAT_SIZE, offset=DAT_LOC, prot=mmap.PROT_READ)

def setReferenceAmplitude():
    amplitude = connectionr.recv(4)
    subprocess.call("./settings a %f" % (struct.unpack("f", amplitude)[0]), shell=True)
    
def setDacMultipliers():
    rawData = connectionr.recv(8)
    multipliers = struct.unpack("2i", rawData)
    subprocess.call("./settings d %d %d" % (multipliers[0], multipliers[1]), shell=True)
    
def setSweepParameters():
    rawData = connectionr.recv(12)
    sweepData = struct.unpack("3f", rawData)
    subprocess.call("./settings s %f %f %f" % (sweepData[0], sweepData[1], sweepData[2]), shell=True)
    
def setPhaseAngle():
    phaseAngle = connectionr.recv(4)
    subprocess.call("./settings p %d" % (struct.unpack("i", phaseAngle)[0]), shell=True)
    
def setMemorySampleFrequency():
    sampleFrequency = connectionr.recv(4)
    subprocess.call("./settings r %d" % (struct.unpack("i", sampleFrequency)[0]), shell=True)
    
def sendSyncCommand():
    subprocess.call("./settings x", shell=True)
    
def setTimeConstant():
    timeConstant = connectionr.recv(4)
    subprocess.call("./settings t %f" % (struct.unpack("f", timeConstant)[0]), shell=True)

def setModulationFrequency():
    modulationFrequency = connectionr.recv(4)
    subprocess.call("./settings f %f" % (struct.unpack("f", modulationFrequency)[0]), shell=True)
    
def setModeParameters():
    rawData = bytearray(connectionr.recv(12))
    rawData.reverse()
    subprocess.call("./settings m %d%d%d%d%d%d%d%d%d%d%d%d" % (struct.unpack("12b", str(rawData))), shell=True)
    
def streamData():
    datalength = 32 #number of bytes for all channels and all data
    #print "Waiting for 5 seconds to allow current scan to complete"
    #time.sleep(5)

    print "Reading data size"
    start = struct.unpack("I", settingMem[START_OFF:START_OFF+4])[0]
    end = struct.unpack("I", settingMem[END_OFF:END_OFF+4])[0]
    messageSize = np.uint32(end - start + NUM_BYTES)
    print "Sending data size : %d" % messageSize
    connectionr.sendall(messageSize)

    print "Waiting to stream"
    data = connectionr.recv(1)
    print "Stream starting"
    
    oldCounter = settingMem[CNT_OFF:CNT_OFF+4]

    try:
        while True:
            newCounter = settingMem[CNT_OFF:CNT_OFF+4]
            try:
                _ = connectionr.recv(1, socket.MSG_DONTWAIT)
                print "Stream finished"
                return
            except:
                pass
            #if (connectionr.recv(1, socket.MSG_PEEK | socket.MSG_DONTWAIT) != ""):
            #ready_to_read, _, _ = select.select([s],[],[],0)
            #if (len(ready_to_read) != 0):
            #    _ = connectionr.recv(1)

            if newCounter != oldCounter:
                oldCounter = newCounter

                start = struct.unpack("I", settingMem[START_OFF:START_OFF+4])[0]
                end = struct.unpack("I", settingMem[END_OFF:END_OFF+4])[0]

                data = bytearray()
                if start < end:
		    dataSize = end - start + NUM_BYTES
                    #data.extend(dataMem[A_X_POS*DAT_SIZE+start:A_X_POS*DAT_SIZE+start+dataSize])
		
		    data.extend(dataMem[B_X_POS*DAT_SIZE+start:B_X_POS*DAT_SIZE+start+dataSize])
			
		    #data.extend(dataMem[A_Y_POS*DAT_SIZE+start:A_Y_POS*DAT_SIZE+start+dataSize])
		    #data.extend(dataMem[A_AMP_POS*DAT_SIZE+start:A_AMP_POS*DAT_SIZE+start+dataSize])
		    #data.extend(dataMem[A_PH_POS*DAT_SIZE+start:A_PH_POS*DAT_SIZE+start+dataSize])
		    #data.extend(dataMem[B_Y_POS*DAT_SIZE+start:B_Y_POS*DAT_SIZE+start+dataSize])
                    #data.extend(dataMem[B_AMP_POS*DAT_SIZE+start:B_AMP_POS*DAT_SIZE+start+dataSize])
                    #data.extend(dataMem[B_PH_POS*DAT_SIZE+start:B_PH_POS*DAT_SIZE+start+dataSize])
		    
                   

		else:
                    dataSize = DAT_SIZE-start

                    #data.extend(dataMem[A_X_POS*DAT_SIZE+start:A_X_POS*DAT_SIZE+start+dataSize])
                    #data.extend(dataMem[A_X_POS*DAT_SIZE:A_X_POS*DAT_SIZE+end+NUM_BYTES])

                    #data.extend(dataMem[A_Y_POS*DAT_SIZE+start:A_Y_POS*DAT_SIZE+start+dataSize])
                    #data.extend(dataMem[A_Y_POS*DAT_SIZE:A_Y_POS*DAT_SIZE+end+NUM_BYTES])

                    #data.extend(dataMem[A_AMP_POS*DAT_SIZE+start:A_AMP_POS*DAT_SIZE+start+dataSize])
                    #data.extend(dataMem[A_AMP_POS*DAT_SIZE:A_AMP_POS*DAT_SIZE+end+NUM_BYTES])

                    #data.extend(dataMem[A_PH_POS*DAT_SIZE+start:A_PH_POS*DAT_SIZE+start+dataSize])
                    #data.extend(dataMem[A_PH_POS*DAT_SIZE:A_PH_POS*DAT_SIZE+end+NUM_BYTES])

                    data.extend(dataMem[B_X_POS*DAT_SIZE+start:B_X_POS*DAT_SIZE+start+dataSize])
                    data.extend(dataMem[B_X_POS*DAT_SIZE:B_X_POS*DAT_SIZE+end+NUM_BYTES])

                    #data.extend(dataMem[B_Y_POS*DAT_SIZE+start:B_Y_POS*DAT_SIZE+start+dataSize])
                    #data.extend(dataMem[B_Y_POS*DAT_SIZE:B_Y_POS*DAT_SIZE+end+NUM_BYTES])

                    #data.extend(dataMem[B_AMP_POS*DAT_SIZE+start:B_AMP_POS*DAT_SIZE+start+dataSize])
                    #data.extend(dataMem[B_AMP_POS*DAT_SIZE:B_AMP_POS*DAT_SIZE+end+NUM_BYTES])

                    #data.extend(dataMem[B_PH_POS*DAT_SIZE+start:B_PH_POS*DAT_SIZE+start+dataSize])
                    #data.extend(dataMem[B_PH_POS*DAT_SIZE:B_PH_POS*DAT_SIZE+end+NUM_BYTES])

	  	     
                connectionr.sendall(data[0:1*messageSize])
		#for i in xrange(1:messageSize)
			#f.write(data[i])

    except Exception as e:
        print "Stream finished"
        print str(e)
	#f.close()
        
# start server
while True:

    print "Waiting for connection"
    #Wait to accept a connection - blocking call
    connectionr, addr = s.accept()
    print "Connection Established!"
    print "Waiting for go signal..."
    try:
        while True:
            streamData()
            
    except Exception as e:
        print "Error!"
        print str(e)
s.close()
