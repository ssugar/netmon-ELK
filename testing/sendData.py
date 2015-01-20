import socket
from random import randint

dataPoint1 = str(randint(2,99))
dataPoint2 = str(randint(2,99))
dataPoint3 = str(randint(2,99))
dataPoint4 = str(randint(2,99))
dataPoint5 = str(randint(2,99))
dataPoint6 = str(randint(2,99))

UDP_IP = "127.0.0.1"
UDP_PORT = 5005

MESSAGE = """{"Sensor1":""" + dataPoint1 + """, "Sensor2":""" + dataPoint2 + """, "Sensor3":""" + dataPoint3 + """, "Sensor4":""" + dataPoint4 + """, "Sensor5":""" + dataPoint5 + """, "Sensor6":""" + dataPoint6 + "}"

print "UDP target IP:", UDP_IP
print "UDP target port:", UDP_PORT
print "message:", MESSAGE

sock = socket.socket(socket.AF_INET, # Internet
             socket.SOCK_DGRAM) # UDP
sock.sendto(MESSAGE, (UDP_IP, UDP_PORT))
