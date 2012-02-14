#
#  Synchronized publisher

import time
import pickle

# Import ZeroMQ Module
import zmq

# Import Logstash Module
try:
    import logstash
except ImportError:
    logstash = None

# Import Salt Modules
import salt.client
import salt.payload
import salt.utils

#  We wait for 1 subscribers
SUBSCRIBERS_EXPECTED = 1

def __virtual__():
    if not logstash:
        return False
    return 'logstash'

def publish():

    print '*********************************************'
    print 'Logstash Publisher'
    print '*********************************************'

    context = zmq.Context()
    
    # Socket to talk to clients
    publisher = context.socket(zmq.PUB)
    # Prevent publisher overflow from slow subscribers
    publisher.setsockopt(zmq.HWM, 20)

    # Specify the swap space in bytes, this covers all subscribers
    publisher.setsockopt(zmq.SWAP, 25000000)    
    publisher.bind('tcp://*:5561')

    # Socket to receive signals
    syncservice = context.socket(zmq.PULL)
    syncservice.bind('tcp://*:5562')
    print "Setup ZeroMQ sockets"

    # Get synchronization from subscribers
    subscribers = 0
    while subscribers < SUBSCRIBERS_EXPECTED:
        # wait for synchronization request
        print "Awaiting sync request from subscribers"
        msg = syncservice.recv()
        # send synchronization reply
        # syncservice.send('')
        subscribers += 1
        print "+1 subscriber"
   
    # Print a list of all of the minions that are up
    client = salt.client.LocalClient(__opts__['config'])
    
    while True:
	  # send the test ping command to all minions
      minions = client.cmd('*', 'state.highstate')
      
      for minion in minions:
          event = logstash.Event()
          event.setsource(minion)
          event.settype('salt.cmd')
          event.settags(['salt'])
          event.put('salt.cmd', 'state.highstate')
          event.setmessage(str(minions[minion]))

          publisher.send(pickle.dumps(event.to_json()))

      # Sleep for 5 seconds
      time.sleep(5)
