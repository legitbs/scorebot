#!/usr/bin/env python

import string
import random
import subprocess
import socket
import sys
import re
import select
import time
import signal


images = []
agencies = []

outputData = ''

def readline(target):

	global outputData

	while True:
	
		if '\n'  in outputData:
	 		outputline = outputData.splitlines()[0] 
	 		outputData = outputData[len(outputline)+1:]
	 		break

		(r,w,e) = select.select([target.fileno()], [], [],0)

		if r:

			data = target.recv(16000)

	 		data = Data_9_to_8(data)

	 		outputData += data

 	return outputline

def writeline(target, data):

	data = Data_8_to_9(data)

	target.send(data)


def Data_8_to_9(InData):
	#don't feel like doing all the math, make a bit list then reparse it
	Bits = ""
	for i in InData:
		Bits += (("0"*9)+bin(ord(i))[2:])[-9:]

	#now add in enough bits to make sure we can send full bytes
	if len(Bits) % 8:
		Bits += "0"*(8-(len(Bits) % 8))

	Output = ""
	for i in xrange(0, len(Bits), 8):
		Output += chr(int(Bits[i:i+8], 2))

	return Output

def Data_9_to_8(InData):
    #don't feel like doing all the math, make a bit list then reparse it
    Bits = ""
    for i in InData:
            Bits += (("0"*8)+bin(ord(i))[2:])[-8:]
    Output = ""
    i = 0
    bytecount = 0
    while i < len(Bits):
            if i+9 > len(Bits):
                    break;
            c = int(Bits[i+1:i+9], 2)
            bytecount += 1
            Output += chr(c)
            if c == 0xa and ((i+9) % 8) != 0:
                    bitstoeat = 8 - (((bytecount*9)+8) % 8)
                    i += bitstoeat
                    bytecount = 0
            i += 9
    return Output


def addImage():

	print "Adding new image"

	path = ''.join(random.choice(string.ascii_uppercase + string.digits + string.ascii_lowercase) for _ in range (random.randint(5,15)))
	descr = ''.join(random.choice(string.ascii_uppercase + string.digits + string.ascii_lowercase) for _ in range (random.randint(5,15)))
	name = ''.join(random.choice(string.ascii_uppercase + string.digits + string.ascii_lowercase) for _ in range (random.randint(5,15)))

	writeline(uut, 'addImage(name={}, path={}, descr={})\n'.format(name, path, descr))

	output = readline(uut)

	while output == "looking for new imageID":
		output = readline(uut)
		print output

	if output[0:8] == 'ImageID=':
		IDs = re.search("\d+", output)
		print output
	else:
		print "Error adding image"
		print output
		sys.exit(-1)

	images.append([IDs.group(0), name, path, descr])


def updateImage():

	if len(images) == 0:
		return

	print "Updating image"

	selection = random.randint(0, len(images)-1)
	imageID = images[selection][0]

	name = ''.join(random.choice(string.ascii_uppercase + string.digits + string.ascii_lowercase) for _ in range (random.randint(5,15)))
	path = ''.join(random.choice(string.ascii_uppercase + string.digits + string.ascii_lowercase) for _ in range (random.randint(5,15)))
	descr = ''.join(random.choice(string.ascii_uppercase + string.digits + string.ascii_lowercase) for _ in range (random.randint(5,15)))

	command = 'updateImage(imageID={},name={},path={},descr={})\n'.format(imageID, name, path, descr)

	writeline( uut, command )
	print readline(uut)

	# update the list to the new values
	images[selection][1] = name
	images[selection][2] = path
	images[selection][3] = descr


def listImages():

	return
	if len(images) == 0:
		return

	print "Listing images"
	writeline(uut,'listImages()\n')


	for i in range(0, len(images)):

		expectString = 'imageID: {}, imageName: {}  Description: {}'.format(images[i][0], images[i][1], images[i][3])
		output = readline(uut)

		print output
		if ( output != expectString ):
			print "Strings don't match!"
			print "output:",output
			print "expect:",expectString
			sys.exit(-1)

def deleteImage():

	if len(images) == 0:
		return

	selection = random.randint(0, len(images)-1)

	imageID = images[selection][0]

	writeline(uut,'delImage(imageID={})\n'.format(imageID))

	print "Deleting image: ", imageID

	output = readline(uut)

	expectString = 'Image {} deleted'.format(images[selection][0])

	if expectString != output:
		print "Strings don't match!"
		print "output:",output
		print "expect:",expectString

		listImages()
		sys.exit(-1)

	del images[selection]


def addAgency():

	print "Adding new agency"

	agencyName = ''.join(random.choice(string.ascii_lowercase) for _ in range(15))
	agencyURL = ''.join(random.choice(string.ascii_lowercase) for _ in range(15))

	writeline(uut,'addAgency(name={}, url={})\n'.format(agencyName, agencyURL))

	output = readline(uut)

	print "output: ", output

	if output[0:8] != "AgencyID":
		print "Didn't find AgencyID"
		sys.exit(-1)

	IDs = re.search("\d+", output)

	submissions = []
	sales = []
	agencies.append([IDs.group(0), agencyName, agencyURL, submissions, sales])	

def listAgencies():

	if len(agencies) == 0:
		return

	print "Listing agencies"
	writeline(uut,'listAgencies()\n')

	for i in range(0, len(agencies)):

		expectString = 'Agency: {}  ID: {}  URL: {}'.format(agencies[i][1], agencies[i][0], agencies[i][2])
		output = readline(uut)

		# print output

		if ( output != expectString ):
			print "Strings don't match!"
			print "output:",output
			print "expect:",expectString
			sys.exit(-1)

def deleteAgency():

	if len(agencies) == 0:
		return

	print "Deleting an agency"
	selection = random.randint(0, len(agencies)-1)

	agencyID = agencies[selection][0]

	writeline(uut,'delAgency(agencyID={})\n'.format(agencyID))

	output = readline(uut)

	expectString = 'Agency {} deleted'.format(agencies[selection][0])

	if expectString != output:
		print "Strings don't match!"
		print "output:",output
		print "expect:",expectString
		sys.exit(-1)

	del agencies[selection]

def addSubmission():

	if len(agencies) == 0 or len(images) == 0:
		return

	print "Submitting an image"

	selection = random.randint(0, len(agencies)-1)

	agencyID = agencies[selection][0]

	# if all the current images have been submitted to this agency, just return
	if len(images) == len( agencies[selection][3]):
		return

	imageNum = random.randint(0, len(images)-1)
	imageID = images[imageNum][0]

	print agencies[selection][3]

	if imageID in agencies[selection][3]:
		expectString = "ImageID {} not submitted".format(imageID)
	else:
		expectString = "ImageID {} submitted".format(imageID)
		agencies[selection][3].append(imageID)

	command = 'submitImage(imageID={},agencyID={})\n'.format(images[imageNum][0],agencyID)

	print command
	writeline(uut,command)

	output=readline(uut)

	if output != expectString:
		print "Output didn't match expected"
		print "Output: ", output
		print "Expected: ",expectString
		sys.exit(-1)

def recordSale():

	if len(agencies) == 0 or len(images) == 0:
		return

	print "Recording a sale"

	agencyNum = random.randint(0, len(agencies)-1)

	agencyID = agencies[agencyNum][0]


	if len(agencies[agencyNum][3] ) == 0:

		return

	selection = random.randint(0, len(agencies[agencyNum][3])-1)

	imageID = agencies[agencyNum][3][selection]

	price = random.randint(1, 200)

	agencies[agencyNum][4].append([imageID, price])

	writeline(uut,'recordSale(imageID={},agencyID={},price={})\n'.format(imageID, agencyID, price))

	output = readline(uut)

	if output != "Sale recorded":

		print "Output does not match expected results"
		print output
		sys.exit(-1)

def salesByAgency():

	
	if len(images) == 0 or len(agencies) == 0:
		return

	selection = random.randint(0, len(agencies)-1)
	agencyID = agencies[selection][0]

	# if there are no submitted images, why bother
	if len(agencies[selection][3]) == 0:
		return

	print "Sales Report by Agency"

	writeline(uut,'salesReport(agencyID={})\n'.format(agencyID))

	output = readline(uut)
	print "output: ", output

	expectString = 'Agency: {}'.format(agencies[selection][1])

	if output != expectString:

		print "Expected: ",expectString
		print "Received: ",output
		sys.exit(-1)

	# readline(uut)

	for sales in agencies[selection][4]:


		imageID = sales[0]

		for image in images:

			if imageID == image[0]:

				readline(uut)
				break



def imageReportByAgency():

	
	if len(images) == 0 or len(agencies) == 0:
		return

	selection = random.randint(0, len(agencies)-1)
	agencyID = agencies[selection][0]

	# if there are no submitted images just quit
	if len(agencies[selection][3]) == 0:
		return


	print "Image Report by Agency"


	imageNum = random.randint(0, len(agencies[selection][3])-1)
	imageID = agencies[selection][3][imageNum]

	writeline(uut,'salesReport(imageID={}, agencyID={})\n'.format(imageID, agencyID))

	output = readline(uut)

	print "output: ", output


	expectString = 'Agency: {}'.format(agencies[selection][1])

	if output != expectString:

		print "Expected: ",expectString
		print "Received: ",output
		sys.exit(-1)

	agencyCount = 0
	agencySales = 0

	for sales in agencies[selection][4]:

		if sales[0] == imageID:

			if agencyCount == 0:

				for image in images:

					if imageID == image[0]:

						break


				if image[0] == imageID:

					# print "Image was found"
					output = readline(uut)
					# print output
					# output = readline(uut)
					# # print output
					# output = readline(uut)
					# # print output
					# output = readline(uut)
					# print output					

				else:

					# print "Image was NOT found"
					output = readline(uut)
					# print output

					expectString = 'Image {} not found'.format(imageID)

					if output != expectString:

						print "Expected: ", expectString
						print "Received: ", output
						sys.exit(-1)

					output = readline(uut)
					# print output

			readline(uut)

			agencyCount = agencyCount + 1
			agencySales = agencySales + sales[1]

	# output=readline(uut)

	# if output != '':

	# 	print "Line should be blank"
	# 	sys.exit(-1)

	output = readline(uut)

	expectString = 'Agency Totals: {} sales, $ {}'.format(agencyCount, agencySales)

	if output != expectString:

		print "Expected: ",expectString
		print "Received: ",output
		sys.exit(-1)

	# output=readline(uut)

def sendMetadata():

	if len(images) == 0:
		return

	print "Sending metadata"

	selection = random.randint(0, len(images)-1)
	imageID = images[selection][0]

	name = ''.join(random.choice(string.ascii_uppercase + string.digits + string.ascii_lowercase) for _ in range (random.randint(5,16)))
	path = ''.join(random.choice(string.ascii_uppercase + string.digits + string.ascii_lowercase) for _ in range (random.randint(5,16)))
	descr = ''.join(random.choice(string.ascii_uppercase + string.digits + string.ascii_lowercase) for _ in range (random.randint(5,16)))

	metadata = 'name={},path={},descr={}\n'.format(name, path, descr)

	command = 'addMetadata(imageID={},dataSize={})\n'.format( imageID, len(metadata))

	writeline(uut, command )
	print readline(uut)

	writeline(uut, metadata)

	images[selection][1] = name
	images[selection][2] = path
	images[selection][3] = descr

	output=readline(uut)

	expectString = 'Updated imageID : {}'.format(imageID)

	if output != expectString:

		print "Expected: ",expectString
		print "Received: ",output
		sys.exit(-1)		


def imageReport():

	if len(images) == 0:
		return

	print "Requesting Image Report"

	selection = random.randint(0, len(images)-1)
	imageID = images[selection][0]

	writeline(uut,'infoImage(imageID={})\n'.format(imageID))

	output = readline(uut)
	# print output

	if output != "Image Report":
		print "Didn't get image report text"
		# print output1
		print output

		# listImages()
		sys.exit(-1)

	output = readline(uut)
	print "output: ", output
	
	expectString = 'Name: {}  ImageID: {}  Description: {}'.format(images[selection][1],
																			images[selection][0],
																			images[selection][3])
	if output[:len(expectString)] != expectString:
		print "Output did not match!"

		print "Expected: ", expectString
		print "Received: ", output[:len(expectString)]
		sys.exit(-1)


	# output = readline(uut)
	# print "IMAGEID ", output
	# output = readline(uut)
	# print "DESCR ", output
	# output = readline(uut)
	# print "DATE ",output


	for agency in agencies:

		if imageID not in agency[3]:
			continue

		agencyCountTotal = 0
		agencySaleTotal = 0
		totalSales = 0
		totalCount = 0

		for sale in agency[4]:

			if sale[0] == imageID:


				agencyCountTotal = agencyCountTotal + 1
				agencySaleTotal = agencySaleTotal + sale[1]

		output=readline(uut)
		print output

		expectString = 'Agency: {}  Totals: {} sales, $ {}'.format(agency[1], agencyCountTotal, agencySaleTotal)

		if output != expectString:
			print "Received: ", output
			print "Expected: ", expectString
			sys.exit(-1)

		output=readline(uut)
		print output

	output=readline(uut)
	print "Totals line:",output

	# output=readline(uut)
	# print output


address = '127.0.0.1'
port = '7845'

# uncomment this for production
if len(sys.argv) == 2:
        address = '10.5.{}.2'.format(sys.argv[1])

def handler(signum, frame):
        print "Timeout"
        sys.exit(-1)

signal.signal(signal.SIGALRM, handler)
signal.alarm(30)


uut = socket.create_connection([address, port])

try_count = random.randint( 5, 30 )

for _ in xrange(try_count):

	path = random.randint(0, 4)

	print "Path: ", path

	if path == 0:

		addImage()
		addAgency()
		addSubmission()
		recordSale()
		imageReport()
		imageReportByAgency()
		salesByAgency()
		listImages()
		sendMetadata()
		listImages()
		updateImage()
		listImages()
		deleteImage()
		listImages()
		listAgencies()

	elif path == 1:

		addAgency()	
		addImage()
		updateImage()
		imageReport()
		addSubmission()
		listImages()
		addSubmission()
		sendMetadata()
		recordSale()
		salesByAgency()
		sendMetadata()
		listAgencies()
		imageReportByAgency()
		listImages()	
		deleteImage()

	elif path == 2:

		addImage()
		addImage()
		listImages()
		sendMetadata()
		updateImage()
		addAgency()
		listAgencies()
		deleteImage()
		addSubmission()
		recordSale()
		imageReportByAgency()
		listImages()
		imageReport()

	elif path == 3:

		listImages()
		listAgencies()
		addImage()
		listImages()
		addAgency()
		listAgencies()
		addSubmission()
		imageReport()
		recordSale()
		imageReport()
		updateImage()
		listImages()
		sendMetadata()
		listImages()
		imageReportByAgency()
		recordSale()
		imageReportByAgency()
		deleteImage()
		imageReportByAgency()


	elif path == 4:

		addImage()
		addImage()
		addAgency()
		addAgency()
		deleteAgency()
		listAgencies()
		addImage()
		listImages()
		addSubmission()
		addSubmission()
		addSubmission()
		recordSale()
		deleteImage()
		listImages()
		addSubmission()
		recordSale()
		imageReportByAgency()
		imageReport()
		sendMetadata()
		listImages()
		updateImage()
		imageReport()
		deleteImage()
		imageReport()


# if we got here, everything worked great
print ("OK!")
sys.exit(0)


