#!/usr/bin/python

import socket
import hashlib
from Crypto.Cipher import DES
import sys
import struct
import select
import time
from optparse import OptionParser
import random
import string
import subprocess
import itertools

errors = { "SUCCESS": struct.pack('I', 0x00000000), "TOOBIG": struct.pack('I', 0xffffffff), "TOOSMALL": struct.pack('I', 0xfffffffe), "NICKEXISTS": struct.pack('I', 0xfffffffd), "ALREADYTHERE": struct.pack('I', 0xfffffffc), "NONICK": struct.pack('I', 0xfffffffb), "INVALIDNICK": struct.pack('I', 0xfffffffa), "INVALIDCHANNEL": struct.pack('I', 0xfffffff9), "NOTINCHANNEL": struct.pack('I', 0xfffffff8), 'INVALIDSIZE': struct.pack('I', 0xfffffff7)  }

def getit( fd, sz ):
    try:
        data = fd.recv(sz)
    except:
        return False

    return data


def conn( ip, port ):
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        s.connect((ip, port))
    except:
        print '[ERROR] Failed to connect to %s:%d' %(ip, port)
        sys.exit(-1)

    return s

def senddata( fd, data ):
    global cbckeys

    extra = ''
    if 'up' in cbckeys:
        if len(data) % 8:
            extra = '\x00'*(8-(len(data)%8))

        data = 'ENCR' + struct.pack('H', len(data)) + cbckeys['up'].encrypt(data + extra)

    fd.send(data)

def setnick( fd, nick ):
    data = 'NICK'
    data += struct.pack('H', len(nick)) + nick

    senddata( fd, data )

def setupkeys( fd, key ):
    cbckeys = {}

    if len(key) < 8:
        key += 'a'*(8-len(key))

    key = key[:8]

    obj = DES.new( key, DES.MODE_ECB )
    data = 'KEYS' + key
    senddata(s, data)

    x = getit( s, 4)

    if x == False:
        return 0

    keys = getit( s, 32 )

    if x == False:
        return 0

    if len(keys) != 32:
        print 'Error Failed to receive cbc keys rom server'
        return 0
        
    data = obj.decrypt( keys )
    '''
    cbc_up_key = struct.unpack('Q', data[:8])[0] & 0x7f7f7f7f7f7f7f7f
    cbc_up_ivec = struct.unpack('Q', data[8:16])[0] & 0x7f7f7f7f7f7f7f7f
    cbc_down_key = struct.unpack('Q', data[16:24])[0] & 0x7f7f7f7f7f7f7f7f
    cbc_down_ivec = struct.unpack('Q', data[24:])[0] & 0x7f7f7f7f7f7f7f7f

    cbc_up_key = struct.pack('Q', cbc_up_key)
    cbc_up_ivec = struct.pack('Q', cbc_up_ivec)
    cbc_down_key = struct.pack('Q', cbc_down_key)
    cbc_down_ivec = struct.pack('Q', cbc_down_ivec)
    '''

    cbc_up_key = data[:8]
    cbc_up_ivec = data[8:16]
    cbc_down_key = data[16:24]
    cbc_down_ivec = data[24:]
    print hex( struct.unpack('Q', cbc_up_key)[0] ), hex(struct.unpack('Q', cbc_up_ivec)[0]), hex(struct.unpack('Q', cbc_down_key)[0]), hex(struct.unpack('Q', cbc_down_ivec)[0])
    cbckeys['up'] = DES.new( cbc_up_key, DES.MODE_CBC, cbc_up_ivec )
    cbckeys['down'] = DES.new( cbc_down_key, DES.MODE_CBC, cbc_down_ivec)

    return cbckeys


def joinchannel( fd, channel ):
    data = 'JOIN'
    data += struct.pack('H', len(channel)) + channel

    senddata( fd, data )

def genstring( l ):
    z = ''.join( random.choice(string.ascii_uppercase + string.lowercase) for _ in range(l))

    return z

def quit( fd ):
    data = 'QUIT'

    senddata( fd, data )

def read_encrypted( fd ):
    encr = getit( fd, 4 )

    if encr == False:
        return ''

    if encr != 'ENCR':
        #print 'ENCR FAILURE'
        #print encr
        #if len(encr) == 4:
        #    print '%x' %(struct.unpack('I', encr)[0])
        return ''

    z = getit( fd, 2 )
    if z == False:
        return ''

    encr_length = struct.unpack('H', z)[0]

    ol = encr_length

    if encr_length % 8:
        encr_length = encr_length + (8-encr_length%8)

    crypted = getit( fd, encr_length )

    if crypted == False:
        return ''

    data = cbckeys['down'].decrypt(crypted)[:ol]

    return data

def list_users( fd, channel ):
    global cbckeys

    data = 'LIST'
    data += struct.pack('H', len(channel)) + channel

    senddata( fd, data )

    data = read_encrypted( fd )

    if len(data) < 6:
        return []

    cmd = data[:4]

    if cmd != 'LIST':
        print cmd
        print 'LIST FAILURE'
        return []

    data = data[4:]
    chlen = struct.unpack('H', data[:2])[0]

    nicks = []

    if len(data) < chlen + 2:
        return []

    channel = data[2:chlen+2]
    data = data[chlen+2:]

    count = struct.unpack('H', data[:2])[0]
    print channel, count

    data = data[2:]

    for i in range(count):
        l = struct.unpack('H', data[:2])[0]
        n = data[2:l+2]
        nicks.append( n)
        data = data[l+2:]

    return nicks

def messageuser( fd, nick ):
    print 'Messageuser'
    message = genstring( random.randint( 30,40))

    data = 'MSGU'
    data += struct.pack('H', len(nick)) + nick
    data += struct.pack('H', len(message)) + message

    senddata( fd, data )

    data = read_encrypted(fd)

    if len(data) < 6:
        print 'MSGU length too small'
        return 0

    cmd = data[:4]

    if cmd != 'MSGU':
        print 'MSGU cmd failed'
        print cmd
        return 0

    lf = struct.unpack('H', data[4:6])[0]

    if len(data) < lf+6:
        print 'MSGU still too short'
        return 0

    response_nick = data[ 6:lf+6]

    data = data[lf+6:]

    if len(data) < 2:
        print 'MSGU way too short'
        return 0

    lf = struct.unpack('H', data[:2])[0]

    if len(data) < lf+2:
        print 'MSGU damn too short'
        return 0

    response_msg = data[2:]

    #print '<%s>: %s' %(response_nick, response_msg)

    if ( response_msg != message ):
        print 'Response message failed: %s %s' %( response_msg, message )
        return 0

    return 1

def addop( level):
    ops = [ '+', '-', '*', '/']

    if level == 0:
        op = random.choice( ops )
        no = random.randint( 1, 60 )
        nt = random.randint( 1, 60 )
        return op + ' ' + str(no) + ' ' + str(nt)

    op = random.choice ( ops )

    num = random.randint( 1, 60 )

    nt = addop( level - 1 )

    return op + ' ' + str( num ) + ' ' + nt


def genequation( ):

    success = 0

    while success == 0:
        levels = random.randint( 5, 20)

        equation = addop( levels )

        try:
            result = subprocess.check_output( ["./polish", equation] )
        except:
            continue

        success = 1

    solution = result[9:]
    return [equation, solution]

def solve( fd, nick ):
    global eql

    print 'Solve'
    equation = random.choice( eql )

    #result = subprocess.check_output( ["./polish", equation[0]] )

    #solution = int( result[9:])

    data = 'SLVE'
    data += struct.pack('H', len(nick)) + nick
    data += struct.pack('H', len(equation[0])) + equation[0]

    senddata( fd, data )

    data = read_encrypted(fd)

    if len(data) < 6:
        return 0

    cmd = data[:4]

    if cmd != 'SLVR':
        print 'SOLVER failed'
        print cmd
        return 0

    ln = struct.unpack('H', data[4:6])[0]

    if len( data ) < ln + 6:
        return 0

    response_nick = data[6:ln+6]

    if response_nick != nick:
        print 'Response nick solver failed: %s %s' %(response_nick, nick)
        return 0

    data = data[ln+6:]

    if len(data) < 6:
        return 0

    ln = struct.unpack('H', data[:2])[0]

    if ln != 4:
        print 'Solver solution length failed'
        return 0

    value = struct.unpack('i', data[2:])[0]

    if value != int(equation[1]):
        print 'Invalid solv solution: %d expected %d' %(value, int(equation[1]))
        return 0

    #print 'Received correct solution'
    return 1

def getflag( fd, nick ):
    print 'flag'
    data = 'FLAG'
    data += struct.pack('H', len(nick)) + nick

    senddata( fd, data )

    data = read_encrypted( fd )

    if len(data) < 6:
        return 0

    cmd = data[:4]

    if cmd != 'FLGR':
        print 'FLGR failed......'
        print cmd
        print nick
        return 0

    lf = struct.unpack('H', data[4:6])[0]

    if len(data) < lf+6:
        print 'FLGR length too small'
        return 0

    response_nick = data[6:lf+6]

    data = data[lf+6:]

    if len(data) < 66:
        print 'Data is less than 66: %d %s' %(len(data), data)
        return 0

    lf = struct.unpack('H', data[:2])[0]

    response_flag = data[2:]

    if ( response_nick != nick ):
        print 'Response flag nick failed: is: %s should be: %s' %(response_nick, nick)
        return 0

    if len(response_flag) != 64:
        print 'Response flag sha failed: len: %d %s' %(len(response_flag), response_flag)
        return 0

    #print '<%s>: Flag sha: %s' %(response_nick, response_flag)

    return 1

def run_check( fd, already_confirmed ):
    global cbckeys

    print 'Generating list to check'
    avail = list_users( s, 'hoponmypoll')

    confirmed = []

    for x in avail:
        if x.startswith( 'team') == False:
            continue

        if x in already_confirmed:
            print '%s already confirmed this round' %x
            confirmed.append( x )
            continue

        print 'Polling %s' %x
        chkcount = random.randint( 5, 7)
        i = 0

        fail = 0
        while i < chkcount:
            sl = random.choice( [ solve, messageuser, getflag ])
            
            if sl( fd, x, ) == 0:
                fail += 1

            i += 1
            time.sleep(1)

        if fail < (chkcount*.5):
       	    confirmed.append(x)
        else:
            print '%s failed %d out of %d' %(x, fail, chkcount)

    print 'Nicks confirmed this check: ', confirmed
        
    return confirmed

def setuplistener( ip, port ):
    s = socket.socket( socket.AF_INET, socket.SOCK_STREAM )
    s.setsockopt( socket.SOL_SOCKET, socket.SO_REUSEADDR, 1 )

    try:
        s.bind( (ip, port ) )
        s.listen(10)
    except:
        print '[ERROR] Failed to bind to %s:%d' %(self.address, self.port)
        sys.exit(0)

    return s

def handle_server_data( s ):
    data = read_encrypted( s )

    if len(data) < 4:
        return 0

    if ( data[:4] == 'PING'):
        senddata( s, "PONG")
    elif ( data[:4] == 'FLAG'):
        if len(data) < 6:
            return 0
        ll = struct.unpack('H', data[4:6])[0]

        if len(data) < ll+6:
            return 0

        nick = data[6:ll+6]

        z = '-----------------------eat a bag of dicks-----------------------'
        data = 'FLGR'
        data += struct.pack('H', len(nick)) + nick
        data += struct.pack('H', len(z)) + z
        senddata( s, data)

    return

def sendping( fd ):
    data = 'PING'

    senddata(s, data)

    data = read_encrypted(fd)

    if data != 'PONG':
        print 'ping fail'

    return

def make_equation_list( count ):
    global eql

    eql = []

    print 'Generating equations'
    for i in range( count ):
        eql.append( genequation() )
    print 'Equations generated'

    return

if __name__ == '__main__':
    global cbckeys

    cbckeys = {}

    make_equation_list( 30 )

    nick = "admin"
    key = genstring( random.randint( 5, 8 ) )

    print 'Connected to server'
    l = setuplistener( 'localhost', 2000 )
    l.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)

    ## Server connection
    s = conn( '10.5.17.4', 666 )

    s.settimeout( 2 )
    cbckeys = setupkeys( s, key )
    setnick( s, nick)
    joinchannel( s, "hoponmypoll")

    lastcheck = 0
    lastfull = 0
    confirmed = []

    while True:
        if time.time() - lastfull > 300:
            print 'Removing all'
            print 'Confirmed this round: ', confirmed
            confirmed = []
            lastfull = time.time()
            lastcheck = 0

        if time.time() - lastcheck > 60:
            print 'Updating check: %d' %(time.time())
            latest = run_check( s, confirmed )
            print 'Check updated %d' %(time.time())
            lastcheck = time.time()

            for team in latest:
                if team not in confirmed:
                    confirmed.append(team)
        

        (rfd, wfd, efd) = select.select( [s, l], [], [], 5)

        if len(rfd) == 0:
            sendping( s )

        for x in rfd:
            if x == s:
                handle_server_data( x )
            else:
                y, addr = x.accept()

                z = getit( y, 2 )

                if z == None:
                    continue

                ll = struct.unpack('H', z)[0]
                team = getit( y, ll )

                if team == False:
                    continue

                if team in confirmed:
                    y.send( struct.pack('I', 1))
                else:
                    y.send( struct.pack('I', 0))
                y.close()


    quit(s)
    s.close()

