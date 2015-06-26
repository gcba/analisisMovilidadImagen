import base64

username = 'superadmin@email.com'
password = 'superadmin.'
authentication = base64.encodestring('%s:%s' % (username, password)).replace('\n', '')
