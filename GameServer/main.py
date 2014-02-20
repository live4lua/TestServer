import socket
import re

UDP_IP = "localhost"
UDP_PORT = 9980

sock = socket.socket(socket.AF_INET, # Internet
                 socket.SOCK_DGRAM) # UDP
sock.bind((UDP_IP, UDP_PORT))


p = re.compile(r'\W+')

print "Sarting UDP Server in (",UDP_IP,",",UDP_PORT,")"

while True:
	data, addr = sock.recvfrom(1024) # buffer size is 1024 bytes
	m = p.split(data) #print "Packet recive:", p.match(data), addr
	print m

	if m[0].isdigit():
		if type(int(m[0])) == int:
			print  "Packet recive:", m[0], addr, m[1],"(",m[2],")"
	else:
		print  "Packet recive:", data
