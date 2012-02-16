import json
import zmq
import time

def returner(ret):
    '''
    Return data to local ZeroMQ socket
    '''
    context = zmq.Context()

    sender = context.socket(zmq.PUSH)
    sender.connect("tcp://127.0.0.1:3434")
    print 'Sending to socket'
    sender.send(json.dumps(ret))

    time.sleep(2)
