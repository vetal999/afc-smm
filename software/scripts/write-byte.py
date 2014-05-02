#!/usr/bin/env python3

import struct
#import sys
from optparse import OptionParser

import serial

# configure the serial connections (the parameters differs on the device you are connecting to)
ser = serial.Serial(port='/dev/ttyUSB0', baudrate=115200, bytesize=8, parity='N', stopbits=1, timeout=None)

def ToInt(data):
    if len(data) > 1 and data[1] == 'x':
        return int(data, 16)
    else:
        return int(data)
        
#filename = "binfile.bin"
filename = "/dev/ttyUSB0"

command = 0b00100010
addr = 0x0000
length = 1
data = 0

parser = OptionParser()
parser.add_option("-d")
parser.add_option("-a")
parser.add_option("-q")
parser.add_option("-s")

(options, args) = parser.parse_args()

if options.d != None:
    print("data = " + options.d)
    data = ToInt(options.d)

if options.a != None:
    print("addr = " + options.a)
    addr = ToInt(options.a)

if options.q != None:
    print("debug mode")
    filename = "binfile.bin"
    
if options.s != None:
    print("size = "+ options.s)
    length = int(options.s)

if length == 1:
    binData = struct.pack('>BBHBB', 0, command, addr, length, data)
else:
    command = 0b00100000
    binData = struct.pack('>BBHBH', 0, command, addr, length, data)

#myfile = open(filename, 'wb')

#ser.open()
ser.write(binData)
#ser.close()
#myfile.write(binData)
