#
#  Synchronized publisher

import time
import json

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

CONFIG_FILE = '/etc/salt/mincheck.json'

def __virtual__():
    if not logstash:
        return False
    return 'logstash'

def check():

    print '*********************************************'
    print 'Minion status checker'
    print '*********************************************'

    print ('Load config from file: %s' % CONFIG_FILE)
    config_data = json.load(open(CONFIG_FILE))

    target = 'tcp://127.0.0.1:5154'
    freq = 60

    for k,v in config_data:
        if k == 'target':
            target = v
            config_data.remove(k)
        elif k == 'freq':
            freq = int(v)
            config_data.remove(k)

    print ('Target is %s, frequency is %d' % (target,freq))
    context = zmq.Context()
    
    # Socket to talk to Logstash
    sender = context.socket(zmq.PUSH)
    # Prevent publisher overflow from slow subscribers
    sender.setsockopt(zmq.HWM, 20)
    sender.connect(target)
   
    # Print a list of all of the minions that are up
    client = salt.client.LocalClient(__opts__['config'])
    
    while True:        
        # send the commands to the salt client
        for key,cmds in config_data:
            fun = cmds['fun']
            tgt = cmds['tgt']
            arg = cmds.get('arg',())
            timeout = cmds.get('timeout',None)
            expr_form = cmds.get('expr_form','glob')
            ret = cmds.get('ret','')
            print ('Fun is %s, Tgt is %s, Arg is %s, Timeout is %s, Expr Form is %s, Ret is %s' % (cmd, val,arg,timeout,expr_form,ret))
            # Call the salt client and get results
            minions = client.cmd(tgt,fun,arg,timeout,expr_form,ret)
      
            for minion in minions:
                event = logstash.Event()
                event.setsource(minion)
                event.put('salt.fun', fun)
                event.put('salt.tgt', tgt)
                if len(arg) > 0:
                    event.put('salt.arg',arg)
                print minions[minion]
                event.setmessage(str(minions[minion]))
                # Send event to ZeroMQ socket
                sender.send(json.dumps(event.to_json()))

        # Sleep for some time
        time.sleep(freq)
