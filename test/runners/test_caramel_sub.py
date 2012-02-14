#
#  Synchronized publisher
import zmq
import time
import pickle

print '********************************'
print 'Logstash Subscriber'
print '********************************' 

context = zmq.Context()

# Connect our subscriber socket
subscriber = context.socket(zmq.SUB)
subscriber.setsockopt(zmq.IDENTITY, "Hello")
subscriber.setsockopt(zmq.SUBSCRIBE, "")
subscriber.connect("tcp://localhost:5561")

# Syncronize with the publisher
sync = context.socket(zmq.PUSH)
sync.connect("tcp://localhost:5562")
print "Sending sync ready notice"
sync.send("")
print "Sync ready sent"

# Get updates, expect random Ctrl-C death
while True:
    data = subscriber.recv()
    if data == "END":
        break
    minions = pickle.loads(data)
    print minions
