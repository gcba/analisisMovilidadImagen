import base64

username = 'USERNAME'
password = 'PASSWORD'
authentication = base64.encodestring('%s:%s' % (username, password)).replace('\n', '')
