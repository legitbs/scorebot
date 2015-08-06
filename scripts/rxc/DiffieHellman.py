"""
PyDHE - Diffie-Hellman Key Exchange in Python
Copyright (C) 2013 by Mark Loiseau
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
For more information:
http://blog.markloiseau.com/2013/01/diffie-hellman-tutorial-in-python/
"""

from binascii import hexlify
import hashlib

# If a secure random number generator is unavailable, exit with an error.
try:
	import Crypto.Random.random
	secure_random = Crypto.Random.random.getrandbits
except ImportError:
	import OpenSSL
	secure_random = lambda x: long(hexlify(OpenSSL.rand.bytes(x>>3)), 16)


class DiffieHellman(object):
	"""
	A reference implementation of the Diffie-Hellman protocol.
	This class uses the 6144-bit MODP Group (Group 17) from RFC 3526.
	This prime is sufficient to generate an AES 256 key when used with a 540+ bit
	exponent.
	"""

	prime = 1552518092300708935130918131258481755631334049434514313202351194902966239949102107258669453876591642442910007680288864229150803718918046342632727613031282983744380820890196288509170691316593175367469551763119843371637221007210577919
	generator = 2
	
	def __init__(self):
		"""
		Generate the public and private keys.
		"""
		self.privateKey = self.genPrivateKey(256)
		self.publicKey = self.genPublicKey()

	
	def genPrivateKey(self, bits):
		"""
		Generate a private key using a secure random number generator.
		"""
		return secure_random(bits)

	
	def genPublicKey(self):
		"""
		Generate a public key X with g**x % p.
		"""
		return pow(self.generator, self.privateKey, self.prime)


	def checkPublicKey(self, otherKey):
		"""
		Check the other party's public key to make sure it's valid.
		Since a safe prime is used, verify that the Legendre symbol is equal to one.
		"""
		if(otherKey > 2 and otherKey < self.prime - 1):
			if(pow(otherKey, (self.prime - 1)/2, self.prime) == 1):
				return True
		return False

		
	def genSecret(self, privateKey, otherKey):
		"""
		Check to make sure the public key is valid, then combine it with the
		private key to generate a shared secret.
		"""
		if(self.checkPublicKey(otherKey) == True):
			sharedSecret = pow(otherKey, privateKey, self.prime)
			return sharedSecret
		else:
			raise Exception("Invalid public key.")
			
	
	def genKey(self, otherKey):
		"""
		Derive the shared secret, then hash it to obtain the shared key.
		"""
		self.sharedSecret = self.genSecret(self.privateKey, otherKey)
		s = hashlib.sha256()
		s.update(str(self.sharedSecret))
		self.key = s.digest()
		
	def getKey(self):
		"""
		Return the shared secret key
		"""
		return self.key


	def showParams(self):
		"""
		Show the parameters of the Diffie Hellman agreement.
		"""
		print "Parameters:"
		print
		print "Prime: ", self.prime
		print "Generator: ", self.generator
		print "Private key: ", self.privateKey
		print "Public key: ", self.publicKey
		print


	def showResults(self):
		"""
		Show the results of a Diffie-Hellman exchange.
		"""
		print "Results:"
		print
		print "Shared secret: ", self.sharedSecret
		print "Shared key: ", hexlify(self.key)
		print


if __name__=="__main__":
	"""
	Run an example Diffie-Hellman exchange 
	"""
	
	a = DiffieHellman()
	b = DiffieHellman()
	
	a.genKey(b.publicKey)
	b.genKey(a.publicKey)

	if(a.getKey() == b.getKey()):
		print "Shared keys match."
		print "Key:", hexlify(a.key)
	else:
		print "Shared secrets didn't match!"
		print "Shared secret: ", a.genSecret(b.publicKey)
		print "Shared secret: ", b.genSecret(a.publicKey)
