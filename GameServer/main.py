import socket
import re

UDP_IP = "localhost"
UDP_PORT = 9980


ClientMd5 = "170f2b9ae1c722003930a27166276c47"

sock = socket.socket(socket.AF_INET, # Internet
                 socket.SOCK_DGRAM) # UDP
sock.bind((UDP_IP, UDP_PORT))


p = re.compile(r'\W+')

print "Sarting UDP Server in (",UDP_IP,",",UDP_PORT,")"

while True:
	data, addr = sock.recvfrom(1024) # buffer size is 1024 bytes
	m = p.split(data) #print "Packet recive:", p.match(data), addr

	if m[0].isdigit() and m[3] == ClientMd5:
		if type(int(m[0])) == int:
			print  "Packet recive:", m[0], addr, m[1],"(",m[2],")"
	else:
		print  "Packet recive:", data
