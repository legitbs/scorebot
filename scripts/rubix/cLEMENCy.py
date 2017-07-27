import base64

# Registers
R00 = 0
R01 = 1
R02 = 2
R03 = 3
R04 = 4
R05 = 5
R06 = 6
R07 = 7
R08 = 8
R09 = 9
R10 = 10
R11 = 11
R12 = 12
R13 = 13
R14 = 14
R15 = 15
R16 = 16
R17 = 17
R18 = 18
R19 = 19
R20 = 20
R21 = 21
R22 = 22
R23 = 23
R24 = 24
R25 = 25
R26 = 26
R27 = 27
R28 = 28
ST  = 29
RA  = 30
PC  = 31

# branch conditions
N = 0
E = 1
L = 2
LE = 3
G = 4
GE = 5
NO = 6
O = 7
NS = 8
S = 9
SL = 10
SLE = 11
SG = 12
SGE = 13
ALWAYS = 15

def Bin2Hex(Bin):
	Hex = ''
	if len(Bin) == 54:
		Hex = hex(int(Bin[0:2], 2))
		for x in xrange(2, 54, 4):
			Hex += hex(int(Bin[x:x+4], 2))
	elif len(Bin) == 27:
		Hex = hex(int(Bin[0:3], 2))
		for x in xrange(3, 27, 4):
			Hex += hex(int(Bin[x:x+4], 2))
	elif len(Bin) == 17:
		Hex = hex(int(Bin[0:1], 2))
		for x in xrange(1, 17, 4):
			Hex += hex(int(Bin[x:x+4], 2))
	elif len(Bin) == 18:
		Hex = hex(int(Bin[0:2], 2))
		for x in xrange(2, 18, 4):
			Hex += hex(int(Bin[x:x+4], 2))
	else:
		return "Unrecognized instruction length: {} {}".format(len(Bin), Bin)

	return(Hex.replace('0x', ''))

def Hex2Bytes(Hex):
	if len(Hex) % 2:
		return(base64.b16decode(Hex+"0"))
	return(base64.b16decode(Hex))

def AD(rA, rB, rC, UF = 1):
	Instr = '0000000'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	Instr += ("0"*8+(bin(rC)[2:]))[-5:]
	Instr += '0000'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def ADC(rA, rB, rC, UF = 1):
	Instr = '0100000'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	Instr += ("0"*8+(bin(rC)[2:]))[-5:]
	Instr += '0000'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def ADCI(rA, rB, Immediate, UF = 1):
	Instr = '0100000'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	if Immediate < 0:
		Immediate *= -1
		Instr += (bin(Immediate - (1<<7))[2:])[-7:]
	else:
		Instr += ("0"*8+(bin(Immediate)[2:]))[-7:]
#	Instr += ("0"*8+(bin(Immediate)[2:]))[-7:]
	Instr += '01'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def ADCIM(rA, rB, Immediate, UF = 1):
	Instr = '0100010'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	if Immediate < 0:
		Immediate *= -1
		Instr += (bin(Immediate - (1<<7))[2:])[-7:]
	else:
		Instr += ("0"*8+(bin(Immediate)[2:]))[-7:]
#	Instr += ("0"*8+(bin(Immediate)[2:]))[-7:]
	Instr += '01'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def ADCM(rA, rB, rC, UF = 1):
	Instr = '0100010'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	Instr += ("0"*8+(bin(rC)[2:]))[-5:]
	Instr += '0000'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def ADF(rA, rB, rC, UF = 1):
	Instr = '0000001'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	Instr += ("0"*8+(bin(rC)[2:]))[-5:]
	Instr += '0000'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def ADFM(rA, rB, rC, UF = 1):
	Instr = '0000011'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	Instr += ("0"*8+(bin(rC)[2:]))[-5:]
	Instr += '0000'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def ADI(rA, rB, Immediate, UF = 1):
	Instr = '0000000'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	if Immediate < 0:
		Immediate *= -1
		Instr += (bin(Immediate - (1<<7))[2:])[-7:]
	else:
		Instr += ("0"*8+(bin(Immediate)[2:]))[-7:]
#	Instr += ("0"*8+(bin(Immediate)[2:]))[-7:]
	Instr += '01'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def ADIM(rA, rB, Immediate, UF = 1):
	Instr = '0000010'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	if Immediate < 0:
		Immediate *= -1
		Instr += (bin(Immediate - (1<<7))[2:])[-7:]
	else:
		Instr += ("0"*8+(bin(Immediate)[2:]))[-7:]
#	Instr += ("0"*8+(bin(Immediate)[2:]))[-7:]
	Instr += '01'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def ADM(rA, rB, rC, UF = 1):
	Instr = '0000010'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	Instr += ("0"*8+(bin(rC)[2:]))[-5:]
	Instr += '0000'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def AN(rA, rB, rC, UF = 1):
	Instr = '0010100'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	Instr += ("0"*8+(bin(rC)[2:]))[-5:]
	Instr += '0000'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def ANI(rA, rB, Immediate, UF = 1):
	Instr = '0010100'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	if Immediate < 0:
		Immediate *= -1
		Instr += (bin(Immediate - (1<<7))[2:])[-7:]
	else:
		Instr += ("0"*8+(bin(Immediate)[2:]))[-7:]
#	Instr += ("0"*8+(bin(Immedate)[2:]))[-7:]
	Instr += '01'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def ANM(rA, rB, rC, UF = 1):
	Instr = '0010110'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	Instr += ("0"*8+(bin(rC)[2:]))[-5:]
	Instr += '0000'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def B(Condition, Offset, UF = 1):
	Instr = '110000'
	Instr += ("0"*8+(bin(Condition)[2:]))[-4:]
	if Offset < 0:
		Offset *= -1
		Instr += (bin(Offset - (1<<17))[2:])[-17:]
	else:
		Instr += ("0"*17+(bin(Offset)[2:]))[-17:]

	return(Bin2Hex(Instr))

def BF(rA, rB, UF = 1):
	Instr = '101001100'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	Instr += '1000000'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def BFM(rA, rB, UF = 1):
	Instr = '101001110'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	Instr += '1000000'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def BR(Condition, rA):
	Instr = '110010'
	Instr += ("0"*8+(bin(Condition)[2:]))[-4:]
	Instr += ("0"*17+(bin(rA)[2:]))[-5:]
	Instr += '0000'

	return(Bin2Hex(Instr))

def BRA(Location):
	Instr = '111000100'
	Instr += ("0"*27+(bin(Location)[2:]))[-27:]

	return(Bin2Hex(Instr))

def BRR(Offset):
	Instr = '111000000'
	Instr += ("0"*27+(bin(Offset)[2:]))[-27:]

	return(Bin2Hex(Instr))

def C(Condition, Offset):
	Instr = '110101'
	Instr += ("0"*8+(bin(Condition)[2:]))[-4:]
	Instr += ("0"*17+(bin(Offset)[2:]))[-17:]

	return(Bin2Hex(Instr))

def CAA(Location):
	Instr = '111001100'
	Instr += ("0"*27+(bin(Location)[2:]))[-27:]

	return(Bin2Hex(Instr))

def CAR(Offset):
	Instr = '111001000'
	Instr += ("0"*27+(bin(Offset)[2:]))[-27:]

	return(Bin2Hex(Instr))

def CM(rA, rB):
	Instr = '10111000'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]

	return(Bin2Hex(Instr))

def CMF(rA, rB):
	Instr = '10111010'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]

	return(Bin2Hex(Instr))

def CMFM(rA, rB):
	Instr = '10111110'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]

	return(Bin2Hex(Instr))

def CMI(rA, Immediate):
	Instr = '10111001'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	if Immediate < 0:
		Immediate *= -1
		Instr += (bin(Immediate - (1<<14))[2:])[-14:]
	else:
		Instr += ("0"*14+(bin(Immediate)[2:]))[-14:]
#	Instr += ("0"*14+(bin(Immediate)[2:]))[-14:]

	return(Bin2Hex(Instr))

def CMIM(rA, Immediate):
	Instr = '10111101'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	if Immediate < 0:
		Immediate *= -1
		Instr += (bin(Immediate - (1<<14))[2:])[-14:]
	else:
		Instr += ("0"*14+(bin(Immediate)[2:]))[-14:]
#	Instr += ("0"*14+(bin(Immediate)[2:]))[-14:]

	return(Bin2Hex(Instr))

def CMM(rA, rB):
	Instr = '10111100'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]

	return(Bin2Hex(Instr))

def CR(Condition, rA):
	Instr = '110111'
	Instr += ("0"*8+(bin(Condition)[2:]))[-4:]
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += '000'

	return(Bin2Hex(Instr))

def DBRK():
	Instr = '11111111111111111'

	return(Bin2Hex(Instr))

def DI(rA):
	Instr = '101000000101'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += '0'

	return(Bin2Hex(Instr))

def DMT(rA, rB, rC):
	Instr = '0110100'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	Instr += ("0"*8+(bin(rC)[2:]))[-5:]
	Instr += '00000'

	return(Bin2Hex(Instr))

def DV(rA, rB, rC, UF = 1):
	Instr = '0001100'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	Instr += ("0"*8+(bin(rC)[2:]))[-5:]
	Instr += '0000'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def DVF(rA, rB, rC, UF = 1):
	Instr = '0001101'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	Instr += ("0"*8+(bin(rC)[2:]))[-5:]
	Instr += '0000'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def DVFM(rA, rB, rC, UF = 1):
	Instr = '0001111'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	Instr += ("0"*8+(bin(rC)[2:]))[-5:]
	Instr += '0000'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def DVI(rA, rB, Immediate, UF = 1):
	Instr = '0001100'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	if Immediate < 0:
		Immediate *= -1
		Instr += (bin(Immediate - (1<<7))[2:])[-7:]
	else:
		Instr += ("0"*7+(bin(Immediate)[2:]))[-7:]
#	Instr += ("0"*8+(bin(Immediate)[2:]))[-7:]
	Instr += '01'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def DVIM(rA, rB, Immediate, UF = 1):
	Instr = '0001110'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	if Immediate < 0:
		Immediate *= -1
		Instr += (bin(Immediate - (1<<7))[2:])[-7:]
	else:
		Instr += ("0"*7+(bin(Immediate)[2:]))[-7:]
#	Instr += ("0"*8+(bin(Immediate)[2:]))[-7:]
	Instr += '01'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def DVIS(rA, rB, Immediate, UF = 1):
	Instr = '0001100'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	if Immediate < 0:
		Immediate *= -1
		Instr += (bin(Immediate - (1<<7))[2:])[-7:]
	else:
		Instr += ("0"*7+(bin(Immediate)[2:]))[-7:]
#	Instr += ("0"*8+(bin(Immediate)[2:]))[-7:]
	Instr += '11'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def DVISM(rA, rB, Immediate, UF = 1):
	Instr = '0001110'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	if Immediate < 0:
		Immediate *= -1
		Instr += (bin(Immediate - (1<<7))[2:])[-7:]
	else:
		Instr += ("0"*7+(bin(Immediate)[2:]))[-7:]
#	Instr += ("0"*8+(bin(Immediate)[2:]))[-7:]
	Instr += '11'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def DVM(rA, rB, rC, UF = 1):
	Instr = '0001110'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	Instr += ("0"*8+(bin(rC)[2:]))[-5:]
	Instr += '0000'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def DVS(rA, rB, rC, UF = 1):
	Instr = '0001100'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	Instr += ("0"*8+(bin(rC)[2:]))[-5:]
	Instr += '0010'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def DVSM(rA, rB, rC, UF = 1):
	Instr = '0001110'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	Instr += ("0"*8+(bin(rC)[2:]))[-5:]
	Instr += '0010'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def EI(rA):
	Instr = '101000000100'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += '0'

	return(Bin2Hex(Instr))

def FTI(rA, rB):
	Instr = '101000101'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	Instr += '00000000'

	return(Bin2Hex(Instr))

def FTIM(rA, rB):
	Instr = '101000111'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	Instr += '00000000'

	return(Bin2Hex(Instr))

def HT():
	Instr = '101000000011000000'

	return(Bin2Hex(Instr))

def IR():
	Instr = '101000000001000000'

	return(Bin2Hex(Instr))

def ITF(rA, rB):
	Instr = '101000100'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	Instr += '00000000'

	return(Bin2Hex(Instr))

def ITFM(rA, rB):
	Instr = '101000110'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	Instr += '00000000'

	return(Bin2Hex(Instr))

def LDS(rA, rB, RegisterCount = 0, AdjustRb = 0, MemoryOffset = 0):
	Instr = '1010100'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	Instr += ("0"*8+(bin(RegCount)[2:]))[-5:]
	Instr += ("0"*8+(bin(AdjustRb)[2:]))[-2:]
	if MemoryOffset < 0:
		MemoryOffset *= -1
		Instr += (bin(MemoryOffset - (1<<27))[2:])[-27:]
	else:
		Instr += ("0"*27+(bin(MemoryOffset)[2:]))[-27:]
#	Instr += ("0"*27+(bin(MemOffset)[2:]))[-27:]
	Instr += '000'

	return(Bin2Hex(Instr))

def LDT(rA, rB, RegisterCount = 0, AdjustRb = 0, MemoryOffset = 0):
	Instr = '1010110'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	Instr += ("0"*8+(bin(RegCount)[2:]))[-5:]
	Instr += ("0"*8+(bin(AdjustRb)[2:]))[-2:]
	if MemoryOffset < 0:
		MemoryOffset *= -1
		Instr += (bin(MemoryOffset - (1<<27))[2:])[-27:]
	else:
		Instr += ("0"*27+(bin(MemoryOffset)[2:]))[-27:]
#	Instr += ("0"*27+(bin(MemOffset)[2:]))[-27:]
	Instr += '000'

	return(Bin2Hex(Instr))

def LDW(rA, rB, RegisterCount = 0, AdjustRb = 0, MemoryOffset = 0):
	Instr = '1010101'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	Instr += ("0"*8+(bin(RegCount)[2:]))[-5:]
	Instr += ("0"*8+(bin(AdjustRb)[2:]))[-2:]
	if MemoryOffset < 0:
		MemoryOffset *= -1
		Instr += (bin(MemoryOffset - (1<<27))[2:])[-27:]
	else:
		Instr += ("0"*27+(bin(MemoryOffset)[2:]))[-27:]
#	Instr += ("0"*26+(bin(MemOffset)[2:]))[-27:]
	Instr += '000'

	return(Bin2Hex(Instr))

def MD(rA, rB, rC, UF = 1):
	Instr = '0010000'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	Instr += ("0"*8+(bin(rC)[2:]))[-5:]
	Instr += '0000'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def MDF(rA, rB, rC, UF = 1):
	Instr = '0010001'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	Instr += ("0"*8+(bin(rC)[2:]))[-5:]
	Instr += '0000'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def MDFM(rA, rB, rC, UF = 1):
	Instr = '0010011'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	Instr += ("0"*8+(bin(rC)[2:]))[-5:]
	Instr += '0000'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def MDI(rA, rB, Immediate, UF = 1):
	Instr = '0010000'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	if Immediate < 0:
		Immediate *= -1
		Instr += (bin(Immediate - (1<<7))[2:])[-7:]
	else:
		Instr += ("0"*7+(bin(Immediate)[2:]))[-7:]
#	Instr += ("0"*8+(bin(Immediate)[2:]))[-7:]
	Instr += '01'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def MDIM(rA, rB, Immediate, UF = 1):
	Instr = '0010010'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	if Immediate < 0:
		Immediate *= -1
		Instr += (bin(Immediate - (1<<7))[2:])[-7:]
	else:
		Instr += ("0"*7+(bin(Immediate)[2:]))[-7:]
#	Instr += ("0"*8+(bin(Immediate)[2:]))[-7:]
	Instr += '01'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def MDIS(rA, rB, Immediate, UF = 1):
	Instr = '0010000'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	if Immediate < 0:
		Immediate *= -1
		Instr += (bin(Immediate - (1<<7))[2:])[-7:]
	else:
		Instr += ("0"*7+(bin(Immediate)[2:]))[-7:]
#	Instr += ("0"*8+(bin(Immediate)[2:]))[-7:]
	Instr += '11'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def MDISM(rA, rB, Immediate, UF = 1):
	Instr = '0010010'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	if Immediate < 0:
		Immediate *= -1
		Instr += (bin(Immediate - (1<<7))[2:])[-7:]
	else:
		Instr += ("0"*7+(bin(Immediate)[2:]))[-7:]
#	Instr += ("0"*8+(bin(Immediate)[2:]))[-7:]
	Instr += '11'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def MDM(rA, rB, rC, UF = 1):
	Instr = '0010010'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	Instr += ("0"*8+(bin(rC)[2:]))[-5:]
	Instr += '0000'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def MDS(rA, rB, rC, UF = 1):
	Instr = '0010000'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	Instr += ("0"*8+(bin(rC)[2:]))[-5:]
	Instr += '0010'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def MDSM(rA, rB, rC, UF = 1):
	Instr = '0010010'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	Instr += ("0"*8+(bin(rC)[2:]))[-5:]
	Instr += '0010'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def MH(rA, Immediate):
	Instr = '10001'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	if Immediate < 0:
		Immediate *= -1
		Instr += (bin(Immediate - (1<<17))[2:])[-17:]
	else:
		Instr += ("0"*17+(bin(Immediate)[2:]))[-17:]
#	Instr += ("0"*17+(bin(Immediate)[2:]))[-17:]

	return(Bin2Hex(Instr))

def ML(rA, Immediate):
	Instr = '10010'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	if Immediate < 0:
		Immediate *= -1
		Instr += (bin(Immediate - (1<<17))[2:])[-17:]
	else:
		Instr += ("0"*17+(bin(Immediate)[2:]))[-17:]
#	Instr += ("0"*17+(bin(Immediate)[2:]))[-17:]

	return(Bin2Hex(Instr))

def MS(rA, Immediate):
	Instr = '10011'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	if Immediate < 0:
		Immediate *= -1
		Instr += (bin(Immediate - (1<<17))[2:])[-17:]
	else:
		Instr += ("0"*17+(bin(Immediate)[2:]))[-17:]
#	Instr += ("0"*17+(bin(Immediate)[2:]))[-17:]

	return(Bin2Hex(Instr))

def MU(rA, rB, rC, UF = 1):
	Instr = '0001000'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	Instr += ("0"*8+(bin(rC)[2:]))[-5:]
	Instr += '0000'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def MUF(rA, rB, rC, UF = 1):
	Instr = '0001001'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	Instr += ("0"*8+(bin(rC)[2:]))[-5:]
	Instr += '0000'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def MUFM(rA, rB, rC, UF = 1):
	Instr = '0001011'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	Instr += ("0"*8+(bin(rC)[2:]))[-5:]
	Instr += '0000'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def MUI(rA, rB, Immediate, UF = 1):
	Instr = '0001000'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	if Immediate < 0:
		Immediate *= -1
		Instr += (bin(Immediate - (1<<7))[2:])[-7:]
	else:
		Instr += ("0"*7+(bin(Immediate)[2:]))[-7:]
#	Instr += ("0"*8+(bin(Immediate)[2:]))[-7:]
	Instr += '01'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def MIUM(rA, rB, Immediate, UF = 1):
	Instr = '0001010'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	if Immediate < 0:
		Immediate *= -1
		Instr += (bin(Immediate - (1<<7))[2:])[-7:]
	else:
		Instr += ("0"*7+(bin(Immediate)[2:]))[-7:]
#	Instr += ("0"*8+(bin(Immediate)[2:]))[-7:]
	Instr += '01'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def MUIS(rA, rB, Immediate, UF = 1):
	Instr = '0001000'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	Instr += ("0"*8+(bin(Immediate)[2:]))[-7:]
	Instr += '11'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def MUISM(rA, rB, Immediate, UF = 1):
	Instr = '0001010'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	if Immediate < 0:
		Immediate *= -1
		Instr += (bin(Immediate - (1<<7))[2:])[-7:]
	else:
		Instr += ("0"*7+(bin(Immediate)[2:]))[-7:]
#	Instr += ("0"*8+(bin(Immediate)[2:]))[-7:]
	Instr += '11'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def MUM(rA, rB, rC, UF = 1):
	Instr = '0001010'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	Instr += ("0"*8+(bin(rC)[2:]))[-5:]
	Instr += '0000'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def MUS(rA, rB, rC, UF = 1):
	Instr = '0001000'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	Instr += ("0"*8+(bin(rC)[2:]))[-5:]
	Instr += '0010'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def MUSM(rA, rB, rC, UF = 1):
	Instr = '0001010'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	Instr += ("0"*8+(bin(rC)[2:]))[-5:]
	Instr += '0010'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def NG(rA, rB, UF = 1):
	Instr = '101001100'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	Instr += '0000000'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def NGF(rA, rB,  UF = 1):
	Instr = '101001101'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	Instr += '0000000'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def NGFM(rA, rB, UF = 1):
	Instr = '101001111'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	Instr += '0000000'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def NGM(rA, rB, UF = 1):
	Instr = '101001110'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	Instr += '0000000'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def NT(rA, rB, UF = 1):
	Instr = '101001100'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	Instr += '0100000'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def NTM(rA, rB, UF = 1):
	Instr = '101001110'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	Instr += '0100000'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def OR(rA, rB, rC, UF = 1):
	Instr = '0011000'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	Instr += ("0"*8+(bin(rC)[2:]))[-5:]
	Instr += '0000'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def ORI(rA, rB, Immediate, UF = 1):
	Instr = '0011000'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	if Immediate < 0:
		Immediate *= -1
		Instr += (bin(Immediate - (1<<7))[2:])[-7:]
	else:
		Instr += ("0"*7+(bin(Immediate)[2:]))[-7:]
#	Instr += ("0"*8+(bin(Immediate)[2:]))[-7:]
	Instr += '01'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def ORM(rA, rB, rC, UF = 1):
	Instr = '0011010'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	Instr += ("0"*8+(bin(rC)[2:]))[-5:]
	Instr += '0000'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def RE():
	Instr = '101000000000000000'

	return(Bin2Hex(Instr))

def RF(rA):
	Instr = '101000001100'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += '0'

	return(Bin2Hex(Instr))

def RL(rA, rB, rC, UF = 1):
	Instr = '0110000'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	Instr += ("0"*8+(bin(rC)[2:]))[-5:]
	Instr += '0000'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def RLI(rA, rB, Immediate, UF = 1):
	Instr = '1000000'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	if Immediate < 0:
		Immediate *= -1
		Instr += (bin(Immediate - (1<<7))[2:])[-7:]
	else:
		Instr += ("0"*7+(bin(Immediate)[2:]))[-7:]
#	Instr += ("0"*8+(bin(Immediate)[2:]))[-7:]
	Instr += '00'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def RLIM(rA, rB, Immediate, UF = 1):
	Instr = '1000010'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	if Immediate < 0:
		Immediate *= -1
		Instr += (bin(Immediate - (1<<7))[2:])[-7:]
	else:
		Instr += ("0"*7+(bin(Immediate)[2:]))[-7:]
#	Instr += ("0"*8+(bin(Immediate)[2:]))[-7:]
	Instr += '00'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def RLM(rA, rB, rC, UF = 1):
	Instr = '0110010'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	Instr += ("0"*8+(bin(rC)[2:]))[-5:]
	Instr += '0000'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def RMP(rA, rB):
	Instr = '1010010'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	Instr += '0'
	Instr += '00'
	Instr += '0000000'

	return(Bin2Hex(Instr))

def RND(rA, UF = 1):
	Instr = '101001100'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += '000001100000'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def RNDM(rA, UF = 1):
	Instr = '101001110'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += '000001100000'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def RR(rA, rB, rC, UF = 1):
	Instr = '0110001'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	Instr += ("0"*8+(bin(rC)[2:]))[-5:]
	Instr += '0000'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def RRI(rA, rB, Immediate, UF = 1):
	Instr = '1000001'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	if Immediate < 0:
		Immediate *= -1
		Instr += (bin(Immediate - (1<<7))[2:])[-7:]
	else:
		Instr += ("0"*7+(bin(Immediate)[2:]))[-7:]
#	Instr += ("0"*8+(bin(Immediate)[2:]))[-7:]
	Instr += '00'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def RRIM(rA, rB, Immediate, UF = 1):
	Instr = '1000011'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	if Immediate < 0:
		Immediate *= -1
		Instr += (bin(Immediate - (1<<7))[2:])[-7:]
	else:
		Instr += ("0"*7+(bin(Immediate)[2:]))[-7:]
#	Instr += ("0"*8+(bin(Immediate)[2:]))[-7:]
	Instr += '00'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def RRM(rA, rB, rC, UF = 1):
	Instr = '0110011'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	Instr += ("0"*8+(bin(rC)[2:]))[-5:]
	Instr += '0000'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def SA(rA, rB, rC, UF = 1):
	Instr = '0101101'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	Instr += ("0"*8+(bin(rC)[2:]))[-5:]
	Instr += '0000'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def SAI(rA, rB, Immediate, UF = 1):
	Instr = '0111101'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	if Immediate < 0:
		Immediate *= -1
		Instr += (bin(Immediate - (1<<7))[2:])[-7:]
	else:
		Instr += ("0"*7+(bin(Immediate)[2:]))[-7:]
#	Instr += ("0"*8+(bin(Immediate)[2:]))[-7:]
	Instr += '00'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def SAIM(rA, rB, Immediate, UF = 1):
	Instr = '0111111'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	if Immediate < 0:
		Immediate *= -1
		Instr += (bin(Immediate - (1<<7))[2:])[-7:]
	else:
		Instr += ("0"*7+(bin(Immediate)[2:]))[-7:]
#	Instr += ("0"*8+(bin(Immediate)[2:]))[-7:]
	Instr += '00'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def SAM(rA, rB, rC, UF = 1):
	Instr = '0101111'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	Instr += ("0"*8+(bin(rC)[2:]))[-5:]
	Instr += '0000'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def SB(rA, rB, rC, UF = 1):
	Instr = '0000100'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	Instr += ("0"*8+(bin(rC)[2:]))[-5:]
	Instr += '0000'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def SBC(rA, rB, rC, UF = 1):
	Instr = '0100100'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	Instr += ("0"*8+(bin(rC)[2:]))[-5:]
	Instr += '0000'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def SBCI(rA, rB, Immediate, UF = 1):
	Instr = '0100100'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	if Immediate < 0:
		Immediate *= -1
		Instr += (bin(Immediate - (1<<7))[2:])[-7:]
	else:
		Instr += ("0"*7+(bin(Immediate)[2:]))[-7:]
#	Instr += ("0"*8+(bin(Immediate)[2:]))[-7:]
	Instr += '01'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def SBCIM(rA, rB, Immediate, UF = 1):
	Instr = '0100110'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	if Immediate < 0:
		Immediate *= -1
		Instr += (bin(Immediate - (1<<7))[2:])[-7:]
	else:
		Instr += ("0"*7+(bin(Immediate)[2:]))[-7:]
#	Instr += ("0"*8+(bin(Immediate)[2:]))[-7:]
	Instr += '01'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def SBCM(rA, rB, rC, UF = 1):
	Instr = '0100110'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	Instr += ("0"*8+(bin(rC)[2:]))[-5:]
	Instr += '0000'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def SBF(rA, rB, rC, UF = 1):
	Instr = '0000101'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	Instr += ("0"*8+(bin(rC)[2:]))[-5:]
	Instr += '0000'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def SBFM(rA, rB, rC, UF = 1):
	Instr = '0000111'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	Instr += ("0"*8+(bin(rC)[2:]))[-5:]
	Instr += '0000'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def SBI(rA, rB, Immediate, UF = 1):
	Instr = '0000100'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	if Immediate < 0:
		Immediate *= -1
		Instr += (bin(Immediate - (1<<7))[2:])[-7:]
	else:
		Instr += ("0"*7+(bin(Immediate)[2:]))[-7:]
#	Instr += ("0"*8+(bin(Immediate)[2:]))[-7:]
	Instr += '01'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def SBIM(rA, rB, Immediate, UF = 1):
	Instr = '0000110'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	if Immediate < 0:
		Immediate *= -1
		Instr += (bin(Immediate - (1<<7))[2:])[-7:]
	else:
		Instr += ("0"*7+(bin(Immediate)[2:]))[-7:]
#	Instr += ("0"*8+(bin(Immediate)[2:]))[-7:]
	Instr += '01'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def SBM(rA, rB, rC, UF = 1):
	Instr = '0000110'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	Instr += ("0"*8+(bin(rC)[2:]))[-5:]
	Instr += '0000'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def SES(rA, rB):
	Instr = '101000000111'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	Instr += '00000'

	return(Bin2Hex(Instr))

def SEW(rA, rB):
	Instr = '101000001000'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	Instr += '00000'

	return(Bin2Hex(Instr))

def SF(rA):
	Instr = '101000001011'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += '0'

	return(Bin2Hex(Instr))

def SL(rA, rB, rC, UF = 1):
	Instr = '0101000'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	Instr += ("0"*8+(bin(rC)[2:]))[-5:]
	Instr += '0000'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def SLI(rA, rB, Immediate, UF = 1):
	Instr = '0111000'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	if Immediate < 0:
		Immediate *= -1
		Instr += (bin(Immediate - (1<<7))[2:])[-7:]
	else:
		Instr += ("0"*7+(bin(Immediate)[2:]))[-7:]
#	Instr += ("0"*8+(bin(Immediate)[2:]))[-7:]
	Instr += '00'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def SLIM(rA, rB, Immediate, UF = 1):
	Instr = '0111010'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	if Immediate < 0:
		Immediate *= -1
		Instr += (bin(Immediate - (1<<7))[2:])[-7:]
	else:
		Instr += ("0"*7+(bin(Immediate)[2:]))[-7:]
#	Instr += ("0"*8+(bin(Immediate)[2:]))[-7:]
	Instr += '00'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def SLM(rA, rB, rC, UF = 1):
	Instr = '0101010'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	Instr += ("0"*8+(bin(rC)[2:]))[-5:]
	Instr += '0000'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def SMP(rA, rB, MemoryFlags = 1):
	Instr = '1010010'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	Instr += '1'
	Instr += ("0"*8+(bin(MemoryFlags)[2:]))[-2:]
	Instr += '0000000'

	return(Bin2Hex(Instr))

def SR(rA, rB, rC, UF = 1):
	Instr = '0101001'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	Instr += ("0"*8+(bin(rC)[2:]))[-5:]
	Instr += '0000'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def SRI(rA, rB, Immediate, UF = 1):
	Instr = '0111001'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	if Immediate < 0:
		Immediate *= -1
		Instr += (bin(Immediate - (1<<7))[2:])[-7:]
	else:
		Instr += ("0"*7+(bin(Immediate)[2:]))[-7:]
#	Instr += ("0"*8+(bin(Immediate)[2:]))[-7:]
	Instr += '00'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def SRIM(rA, rB, Immediate, UF = 1):
	Instr = '0111011'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	if Immediate < 0:
		Immediate *= -1
		Instr += (bin(Immediate - (1<<7))[2:])[-7:]
	else:
		Instr += ("0"*7+(bin(Immediate)[2:]))[-7:]
#	Instr += ("0"*8+(bin(Immediate)[2:]))[-7:]
	Instr += '00'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def SRM(rA, rB, rC, UF = 1):
	Instr = '0101011'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	Instr += ("0"*8+(bin(rC)[2:]))[-5:]
	Instr += '0000'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def STS(rA, rB, RegCount = 0, AdjustRb = 0, MemOffset = 0):
	Instr = '1011000'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	Instr += ("0"*8+(bin(RegCount)[2:]))[-5:]
	Instr += ("0"*8+(bin(AdjustRb)[2:]))[-2:]
	Instr += ("0"*27+(bin(MemOffset)[2:]))[-27:]
	Instr += '000'

	return(Bin2Hex(Instr))

def STT(rA, rB, RegCount = 0, AdjustRb = 0, MemOffset = 0):
	Instr = '1011010'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	Instr += ("0"*8+(bin(RegCount)[2:]))[-5:]
	Instr += ("0"*8+(bin(AdjustRb)[2:]))[-2:]
	Instr += ("0"*27+(bin(MemOffset)[2:]))[-27:]
	Instr += '000'

	return(Bin2Hex(Instr))

def STW(rA, rB, RegCount = 0, AdjustRb = 0, MemOffset = 0):
	Instr = '1011001'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	Instr += ("0"*8+(bin(RegCount)[2:]))[-5:]
	Instr += ("0"*8+(bin(AdjustRb)[2:]))[-2:]
	Instr += ("0"*27+(bin(MemOffset)[2:]))[-27:]
	Instr += '000'

	return(Bin2Hex(Instr))

def WT():
	Instr = '101000000010000000'

	return(Bin2Hex(Instr))

def XR(rA, rB, rC, UF = 1):
	Instr = '0011100'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	Instr += ("0"*8+(bin(rC)[2:]))[-5:]
	Instr += '0000'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def XRI(rA, rB, Immediate, UF = 1):
	Instr = '0011100'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	if Immediate < 0:
		Immediate *= -1
		Instr += (bin(Immediate - (1<<7))[2:])[-7:]
	else:
		Instr += ("0"*7+(bin(Immediate)[2:]))[-7:]
#	Instr += ("0"*8+(bin(Immediate)[2:]))[-7:]
	Instr += '01'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def XRM(rA, rB, rC, UF = 1):
	Instr = '0011110'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	Instr += ("0"*8+(bin(rC)[2:]))[-5:]
	Instr += '0000'
	Instr += ("0"*8+(bin(UF)[2:]))[-1:]

	return(Bin2Hex(Instr))

def ZES(rA, rB):
	Instr = '101000001001'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	Instr += '00000'

	return(Bin2Hex(Instr))

def ZEW(rA, rB):
	Instr = '101000001010'
	Instr += ("0"*8+(bin(rA)[2:]))[-5:]
	Instr += ("0"*8+(bin(rB)[2:]))[-5:]
	Instr += '00000'

	return(Bin2Hex(Instr))
