#!/usr/bin/env python
import socket               # Import socket module
import serial, time
import binascii
import struct
import SocketServer
import threading
import logging
import Queue
import argparse
import os
import hashlib
import random
from select import select
import sys

# Time to allow a connection to stay open (in seconds)
DIRECTION_LIST = ['north','east','south','west','up','down']

TIMEOUT = 20

MAX_TEAM_NUMBER = 16

#TEST_USERNAME = "Test"
#TEST_PASSWORD = "b085d1bf4cff8b1045750706b11f8662"

FAIL_EXIT_CODE = 0

SLA_CHECK_PORT = 7598

E = 65537
N = 127713237559096456859162440384329319184765043930629306059193106961043729357248991345333807818478592762886897346536339668046663082737576018080706999569899607904576509200118346219709320734780197104056159818430712295438274249934006534622016896686853614596024838698725229857848176809494403034568907629979751897751

DEBUG_PRINT = False

# Foreground colors
FC_NORMAL_RED           = "\x1b[31m"
FC_NORMAL_BLACK         = "\x1b[30m"
FC_NORMAL_GREEN         = "\x1b[32m"
FC_NORMAL_YELLOW        = "\x1b[33m"
FC_NORMAL_BLUE          = "\x1b[34m"
FC_NORMAL_MAGENTA       = "\x1b[35m"
FC_NORMAL_CYAN          = "\x1b[36m"
FC_NORMAL_WHITE         = "\x1b[37m"

FC_BRIGHT_RED           = "\x1b[31;1m"
FC_BRIGHT_BLACK         = "\x1b[30;1m"
FC_BRIGHT_GREEN         = "\x1b[32;1m"
FC_BRIGHT_YELLOW        = "\x1b[33;1m"
FC_BRIGHT_BLUE          = "\x1b[34;1m"
FC_BRIGHT_MAGENTA       = "\x1b[35;1m"
FC_BRIGHT_CYAN          = "\x1b[36;1m"
FC_BRIGHT_WHITE         = "\x1b[37;1m"

COLOR_NO_MORE           = "\x1b[0m"

# SLA team list
sla_team_list = list()
login_npc_list = [ 
[ 'Codephage', '23eca43daf48e632cf7f8512ac708101' ],
[ 'Codewisp', '23eca43daf48e632cf7f8512ac708102' ],
[ 'Crontab', '23eca43daf48e632cf7f8512ac708103' ],
[ 'Codesweeper', '23eca43daf48e632cf7f8512ac708104' ],
[ 'Gatekeeper', '23eca43daf48e632cf7f8512ac708105' ],
[ 'Taskthread', '23eca43daf48e632cf7f8512ac708106' ]
]

login_queue = Queue.Queue()

def recv_line( sockfd ):
        response = ""
        while True:

                data = sockfd.recv(1)

                if not data:
                        break

                if ( data == '\n' ):
                        break

                response += data

        return response

def int_to_bytes(val, num_bytes):
        i = 0
        result_bytes = ''
        while i < num_bytes:
                result_bytes += struct.pack( 'B', val & 0xff )

                val >>= 8
                i += 1

        return result_bytes

def bytes_to_int( byte_string, num_bytes):
        byte_string = byte_string[::-1]
        i = 0
        result_int = 0
        while i < num_bytes:
                result_int <<= 8
                result_int += ord(byte_string[i])

                i+=1

        return result_int

def init_sla_list():
	# Default to SLA pass~
	for i in range( 0, MAX_TEAM_NUMBER ):
		sla_team_list.append(True)

class SLAHandler(SocketServer.BaseRequestHandler):
	def handle(self):
		try:	
			self.request.settimeout(TIMEOUT)
			self.data = self.request.recv(1024).strip()

			print "SLA {} wrote:".format(self.client_address[0])
			print self.data

			if ( self.data.find("TEAM") == 0 ):
				team_num = int(self.data[4:])
			
				if ( team_num <= MAX_TEAM_NUMBER ):
					sla_for_team = sla_team_list[team_num-1]

					if ( sla_for_team == True ):
						self.request.sendall('PASS')
					else:
						self.request.sendall('FAIL')

				else:
					self.request.sendall('ERROR')
			
			self.request.sendall('\n')
			self.request.close()

		except socket.timeout:
			self.request.close()

		return

class SLAServer(SocketServer.ThreadingMixIn, SocketServer.TCPServer):
	
	daemon_threads = True
	allow_reuse_address = True

	pass

def update_team_sla( team_id, status ):
	sla_team_list[team_id-1] = status

class ServicePoller:
	
	def __init__( self, team_id ):
		self.team_id = team_id
		self.sockfd = None
		self.username = ''
		self.password = ''
		self.last_exit_list = None

	def Connect( self, sockfd ):
		username = self.username
		password = self.password
		challenge_line = recv_line( sockfd )

		print challenge_line
		if ( challenge_line != FC_NORMAL_CYAN + 'Welcome to hackerMUD!' ):
			print "Missed banner, exiting"
			return False

		challenge_line = recv_line( sockfd )
		if ( challenge_line != FC_BRIGHT_CYAN + 'Server Login Challenge Data:' ):
			print "Missing challenge data"
			return False

		challenge_line = recv_line( sockfd )
		if ( len(challenge_line) != (32*2) or challenge_line != binascii.hexlify(binascii.unhexlify(challenge_line)) ):
			print len(challenge_line)
			print "Incorrect server challenge random data"
			return False

		server_challenge_data = binascii.unhexlify(challenge_line)

		challenge_line = recv_line( sockfd )
		if ( challenge_line != '' ):
			print "Missing challenge newline"
			return False

		challenge_line = recv_line( sockfd )
		if ( challenge_line != FC_BRIGHT_CYAN + 'Enter authentication token (hexadecimal string -- ex: a3bf..., 1024-bits):' ):
			print "Missing authentication token header"
			return False

		random_bytes = os.urandom(32)

		password_digest = hashlib.sha256( server_challenge_data + self.password ).digest()

		data_to_encrypt = random_bytes + password_digest + struct.pack('B', len(self.username) ) + self.username
		data_to_encrypt = data_to_encrypt + ('\x00' * (97-len(data_to_encrypt)))

		md5_of_data_to_encrypt = hashlib.md5( data_to_encrypt ).digest()

		plaintext_data = data_to_encrypt + md5_of_data_to_encrypt + ('\x00' * (128-len(data_to_encrypt+md5_of_data_to_encrypt)))

		plaintext_int = bytes_to_int( plaintext_data, 128 )

		plaintext_int = bytes_to_int( plaintext_data, 128 )

		if ( plaintext_int > N ):
			print "Critical error -- integer to encrypt larger than N\n"
			return False

		cipher_data = pow( plaintext_int, E, N )	

		auth_token = binascii.hexlify(int_to_bytes(cipher_data, 128))

        	sockfd.sendall( auth_token + '\n' )

		return True

	def DoDirection( self, sockfd ):

		if ( self.last_exit_list == None ):
			chosen_direction = random.choice(DIRECTION_LIST)
			sockfd.sendall( chosen_direction + '\n' )
		else:
			chosen_direction = random.choice(self.last_exit_list).strip()
			print "[DIRECTION=%s]\n" % chosen_direction
			sockfd.sendall( chosen_direction + '\n' )

		# Clear out exits
		self.last_exit_list = None

		return True

	def ReadData( self, sockfd ):
		# Get exit data if it is available
		read_input_data = sockfd.recv(8192)

		# Split the string into a bunch of lines
		read_lines = read_input_data.splitlines()

		# Scan for exits
		exit_list = None
		for line in read_lines:
			if ( line.find( ('%sExits: %s' % (FC_NORMAL_BLUE, FC_NORMAL_WHITE)) ) != -1 ):
				prepend_length = len( ('%sExits: %s' % (FC_NORMAL_BLUE, FC_NORMAL_WHITE) ) )

				exit_list = line[prepend_length:].split(' ')
	
				found = False	
				for item in exit_list:
					if len(item) > 1:
						found = True

				if ( found ):
					self.last_exit_list = list()
					for item in exit_list:
						if len(item) > 1:
							self.last_exit_list.append( item )	
				print "Exit List:\n" 
				print self.last_exit_list

			elif ( line.find( ("%sServer rebooting." % FC_NORMAL_YELLOW) ) != -1 ):
				# Incoming reboot!!!
				self.server_rebooting = True

			elif ( line.find( ("%sYou can't do that while fighting." % FC_NORMAL_RED) ) != -1 or line.find( "%sYou can't do that while fighting." % FC_NORMAL_YELLOW ) != -1 ):
				# Update fighting
				print "Fighting set: %s\n" % line
				self.fighting_status = True

			elif ( line.find( ("%sYou flee " % FC_NORMAL_RED ) ) != -1 ):
				# Update fighting
				self.fighting_status = False

			elif ( line.find( "%sYou leave " % FC_NORMAL_YELLOW ) != -1 ):
				# Update fighting status
				self.fighting_status = False

		return read_input_data, exit_list

	def RunPoll( self, sockfd ):
		# Read until prompt

		# Reset reboot status
		self.server_rebooting = False
		self.fighting_status = False

		# Random action count
		run_command_count = random.randint( 30, 100 )
	
		for i in range(run_command_count):
			read_input_data, exit_list = self.ReadData( sockfd )

			if ( self.server_rebooting == True ):
				# End poll
				print "Server rebooting, stopping poll\n"
				return True

			if ( self.fighting_status == True ):
				# Send flee
				print "Fighting... fleeing!\n"
				sockfd.sendall( "flee\n" )
				time.sleep( random.randint( 10, 30 ) / 10.0 )
				
				continue

			if DEBUG_PRINT:
				print "%s" % read_input_data

			random_action_id = random.randint( 0, 1 )

			if ( random_action_id == 0 or random_action_id == 1 ):
				action_success = self.DoDirection( sockfd )	

			if ( action_success == False ):
				return False

			time.sleep( random.randint( 10, 30 ) / 10.0 )

		# Exit
		try:
			read_input_data, exit_list = self.ReadData( sockfd )
		
			if DEBUG_PRINT:
				print "%s" % read_input_data

			sockfd.sendall( "exit\n" )
		
		except SocketError, e:
			print "Socket error -- sending exit\n"
			return True
		
		# Do poller activities!
		return True
	
	def Run( self ):


		self.host = "10.5." + str(self.team_id) + ".4"
		self.port = 880
		#self.host = "localhost"
		#self.port = 4041

		while ( True ):
			current_login = login_queue.get()

			# Sleep a little (before attempting to use this login)
			time.sleep(5)

			self.username = login_npc_list[current_login][0]
			self.password = login_npc_list[current_login][1]

			#self.username = TEST_USERNAME
			#self.password = TEST_PASSWORD
			
			sla_pass = False

			print "Running thread %d!\n" % self.team_id

			try:
				sockfd = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

				sockfd.connect( (self.host, self.port) )

				sockfd.settimeout( 10.0 )
				
				if ( self.Connect( sockfd ) ):
					sla_poll = self.RunPoll( sockfd )
				else:
					sla_poll = False

			except Exception, e:
				print "Error : " + str(e)
				#raise e
				sla_poll = False

			print "SLA Poll [%d] [%s]" % (self.team_id, str(sla_poll))
			update_team_sla( self.team_id, sla_poll )

			print "Returning NPC %s to the login queue\n" % login_npc_list[current_login][0]

			login_queue.put( current_login )

			time.sleep(10)
			
		return


if __name__ == "__main__":
	parser = argparse.ArgumentParser(description='HackerMUD SLA client')
	#parser.add_argument('-p', '--port', default='/dev/ttyUSB0', help='Sets the serial port')
	program_args = vars(parser.parse_args())
	

	# Initialize the SLA poll results
	init_sla_list()

	# Run SLA poll server
	sla_address = ( '0.0.0.0', SLA_CHECK_PORT )

	sla_server = SLAServer( sla_address, SLAHandler )
	sla_ip, sla_port = sla_server.server_address

	t = threading.Thread(target=sla_server.serve_forever)
	t.setDaemon( True ) # don't hang on exit
	t.start()

	logger = logging.getLogger('client')
	logger.info( 'SLA server on %s:%s', sla_ip, sla_port )

	client_threads = list()
	client_servers = list()

	print "NPC list size: %d\n" % len(login_npc_list)

	for i in range( len(login_npc_list) ):
		login_queue.put( i )

	print "NPC login queue size: %d\n" % login_queue.qsize()

	for i in range( MAX_TEAM_NUMBER ):
		print "Starting client thread %d\n" % (i+1)
		client_servers.append( ServicePoller( i+1 ) )
		client_threads.append( threading.Thread(target=client_servers[i].Run ) )

		client_threads[i].setDaemon( True )
		client_threads[i].start()

	while True:
		time.sleep(10)	

	sla_server.socket.close()
