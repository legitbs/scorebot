
from struct import *
import sys

debug = 0

def Prepend_MBAP(TransID, PDU):
	# MBAP header
	ADU = pack('>H', TransID)
	ADU += pack('>H', 0)
	ADU += pack('>H', len(PDU))
	ADU += PDU

	return ADU

def Send_Invalid_Function(sock, TransID, UnitID, Function):

	PDU = pack('B', UnitID)
	PDU += pack('B', Function) # ReadFileRecord

	ADU = Prepend_MBAP(TransID, PDU)
	if debug: print "Read_File_Record: " + ":".join("{:02x}".format(ord(c)) for c in ADU)
	sock.send(ADU)

def Read_File_Record(sock, TransID, UnitID, FileNum, RecordNum, RecordLen):

	# Form up the PDU
	PDU = pack('B', UnitID)
	PDU += pack('B', 0x14) # ReadFileRecord
	PDU += pack('B', 7)    # number of bytes in the subrequest
	PDU += pack('B', 6)    # reference type
	PDU += pack('>H', FileNum)
	PDU += pack('>H', RecordNum)
	PDU += pack('>H', RecordLen)

	ADU = Prepend_MBAP(TransID, PDU)
	if debug: print "Read_File_Record: " + ":".join("{:02x}".format(ord(c)) for c in ADU)
	sock.send(ADU)

def Read_Registers(sock, TransID, UnitID, StartingReg, NumReg):

	# Form up the write PDU
	PDU =  pack('B', UnitID)
	PDU += pack('B', 0x04)  # function code for read registers
	PDU += pack('>H', StartingReg)
	PDU += pack('>H', NumReg)

	# MBAP header
	ADU = Prepend_MBAP(TransID, PDU)

	if debug: print "Read_Registers: " + ":".join("{:02x}".format(ord(c)) for c in ADU)
	sock.send(ADU)


def Write_Multiple_Registers(sock,TransID,UnitID,StartingReg,NumReg,Values):

	# Form up the write PDU
	PDU =  pack('B', UnitID)
	PDU += pack('B', 0x10)  # function code for write multiple registers
	PDU += pack('>H', StartingReg)
	PDU += pack('>H', NumReg)
	PDU += pack('B', NumReg*2)
	for v in Values:
		PDU += pack('H', v)

	# MBAP header
	ADU = Prepend_MBAP(TransID, PDU)

	if debug: print "Write_Multiple_Registers: " + ":".join("{:02x}".format(ord(c)) for c in ADU)
	sock.send(ADU)

def Write_Single_Register(sock,TransID,UnitID,RegisterAddress,Value):

	# Form up the write PDU
	PDU =  pack('B', UnitID)
	PDU += pack('B', 0x06)  # function code for write multiple registers
	PDU += pack('>H', RegisterAddress)
	PDU += pack('>H', Value)

	# MBAP header
	ADU = Prepend_MBAP(TransID, PDU)

	if debug: print "Write_Single_Register: " + ":".join("{:02x}".format(ord(c)) for c in ADU)
	sock.send(ADU)

def Read_Coils(sock, TransID, UnitID, StartingCoil, Quantity):

	# Form up the PDU
	PDU = pack('B', UnitID)
	PDU += pack('B', 0x01) # ReadCoils
	PDU += pack('>H', StartingCoil)
	PDU += pack('>H', Quantity)

	ADU = Prepend_MBAP(TransID, PDU)
	if debug: print "Read_Coils: " + ":".join("{:02x}".format(ord(c)) for c in ADU)
	sock.send(ADU)

def Write_Single_Coil(sock, TransID, UnitID, Address, Value):

	# Form up the PDU
	PDU = pack('B', UnitID)
	PDU += pack('B', 0x05) # WriteSingleCoil
	PDU += pack('>H', Address)
	PDU += pack('>H', Value)

	ADU = Prepend_MBAP(TransID, PDU)
	if debug: print "Write_Single_Coil: " + ":".join("{:02x}".format(ord(c)) for c in ADU)
	sock.send(ADU)


def Write_Multiple_Coils(sock, TransID, UnitID, StartingAddress, QuantityCoils, Values):

	# Form up the PDU
	PDU = pack('B', UnitID)
	PDU += pack('B', 0x0F) # WriteMultipleCoils
	PDU += pack('>H', StartingAddress)
	PDU += pack('>H', QuantityCoils)
	if QuantityCoils % 8 != 0:
		ByteCount = QuantityCoils/8 + 1
	else:
		ByteCount = QuantityCoils/8

	if len(Values) != ByteCount:
		print "Length of values doesn't match ByteCount"
		sys.exit(-1)
	PDU += pack('B', ByteCount)
	PDU += Values

	ADU = Prepend_MBAP(TransID, PDU)
	if debug: print "Write_Multiple_Coils: " + ":".join("{:02x}".format(ord(c)) for c in ADU)
        sock.send(ADU)

def Read_Response(sock):

	# read in the MBAP header
	buf = ""
	while (len(buf) != 6):
		buf += sock.recv(1)
	raw = buf

	pdu_len = ord(buf[5])

	if debug:
		print "Received MBAP APU"
		print "TransID: {}".format(unpack(">H", buf[0:2])[0])
		print "Length: {}".format(pdu_len)

	# read in the rest of the bytes
	buf = ""
	while (len(buf) != pdu_len):
		buf += sock.recv(1)

	raw += buf

	if debug:
		print "Function: 0x{:02x}".format(ord(buf[1]))
		print "Raw: " + ":".join("{:02x}".format(ord(c)) for c in raw)

	return buf

