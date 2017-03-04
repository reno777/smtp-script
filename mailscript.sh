!#/bin/bash
mkdir /etc/postfix/ssl
cd /etc/postfix/ssl
openssl genrsa -des3 -rand /etc/hosts -out smtpd.key 1024
