``` python
import socket
import binascii
import random
import ipaddress
import logging

def b2a_hexstr(abytes):
    return binascii.b2a_hex(abytes).decode("ascii")

logging.basicConfig(level=logging.DEBUG)
log = logging.getLogger("leiwenyong")

def testI(client: socket):
    remote = {"ip":'',"port":0}
    external = {"ip":'',"port":0}
    stunMessageStun = '0001' # 2 bytes
    messageLength = '0000' # 2 bytes
    messageCookie = '2112A442' # 4 bytes
    transationId = ''.join(random.choice('0123456789ABCDEF') for i in range(24)) # 12 bytes
    # log.info(transationId)
    b1 = binascii.a2b_hex(''.join([stunMessageStun,messageLength,messageCookie,transationId]))
    client.send(b1)
    buf, addr = client.recvfrom(2048)
    msgtype = b2a_hexstr(buf[0:2])
    
    len_message = int(b2a_hexstr(buf[2:4]), 16)
    base = 20
    while len_message:
        attr_type = b2a_hexstr(buf[base:(base + 2)])
        attr_len = int(b2a_hexstr(buf[(base + 2):(base + 4)]), 16)
        
        if attr_type == '802c':
            remote['port'] = int.from_bytes(buf[(base+6):(base+8)],'big')
            remote['ip'] = str(ipaddress.ip_address(buf[(base+8):(base+12)]))
        elif attr_type == '0001':
            external['port'] = int.from_bytes(buf[(base+6):(base+8)],'big')
            external['ip'] = str(ipaddress.ip_address(buf[(base+8):(base+12)]))
        
        base = base + 4 + attr_len
        len_message = len_message - (4 + attr_len)
    return remote,external

# stun.voipia.net
# stun.business-isp.nl
# stun.nextcloud.com
# stun.pure-ip.com
# stun.freeswitch.org
# stun.hot-chilli.net
# stun.cope.es
# stun.telnyx.com
# stun.bethesda.net
# stun.signalwire.com
# stun.nextcloud.com
# stun.m-online.net
# stun.ringostat.com
# stun.sip.us
aaaa = [
    'stun.nextcloud.com:3478'
]
aaaa1 = [
]
for a in aaaa:
    try:
        s1 = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        s1.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        s1.settimeout(2)
        s1.bind(("0.0.0.0",18888))
        s1.connect((a.split(":")[0], int( a.split(":")[1])))

        # test I
        remote1,external1 = testI(s1)
        if(remote1['port']!=0):
            print(a.split(":")[0])
        print("external1: "+str(external1))
        
        # test II
        s2 = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        s2.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        s2.settimeout(2)
        s2.bind(("0.0.0.0",18888))
        s2.connect((remote1['ip'],remote1['port']))
        remote2,external2 = testI(s2)

        print("external2: "+str(external2))
        
    except Exception as e :
        print(e)
    finally:
        s1.close()
        # s2.close()

# test III
```
