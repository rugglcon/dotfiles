#!/usr/bin/python

import imaplib

obj = imaplib.IMAP4_SSL('imap.mail.net', 993)
obj.login('conruggles@gmail.com', 'connorandsamantha12-31-2013')
obj.select()

print(len(obj.search(None, 'unseen')[1][0].split()))
