import json
import zmq
import logstash

def push(target):

    context = zmq.Context()

    receiver = context.socket(zmq.PULL)
    receiver.bind("tcp://127.0.0.1:3434")

    sender = context.socket(zmq.PUSH)
    print target
    sender.connect(target)

    while True:
        # Pull message from internal socket
        ret = json.loads(receiver.recv())
        print ret

        # event = logstash.Event()
        
if __name__ == "__main__":
    import sys
    push(sys.argv[1])
