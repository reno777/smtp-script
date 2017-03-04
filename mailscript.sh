!#/bin/bash
yum install postfix -y
yum -y install cyrus-sasl cyrus-sasl-devel cyrus-sasl-gssapi cyrus-sasl-md5 cyrus-sasl-plain
mkdir /etc/postfix/ssl
cd /etc/postfix/ssl
openssl genrsa -des3 -rand /etc/hosts -out smtpd.key 1024
chmod 600 smtpd.key
openssl req -new -key smtpd.key -out smtpd.csr
openssl x509 -req -days 365 -in smtpd.csr -signkey smtpd.key -out smtpd.crt
openssl rsa -in smtpd.key -out smtpd.key.unencrypted
mv -f smtpd.key.unencrypted smtpd.key
openssl req -new -x509 -extensions v3_ca -keyout cakey.pem -out cacert.pem -days 365

sed -i 's/^inet_interfaces = localhost/#inet_interfaces = localhost/' /etc/postfix/main.cf

echo "myhostname = mail.test.com" >> /etc/postfix/main.cf
echo "mydomain = test.com" >> /etc/postfix/main.cf
echo "myorigin = $mydomain" >> /etc/postfix/main.cf
echo "home_mailbox = mail/" >> /etc/postfix/main.cf
echo "mynetworks = 127.0.0.0/8" >> /etc/postfix/main.cf
echo "inet_interfaces = all" >> /etc/postfix/main.cf
echo "mydestination = $myhostname, localhost.$mydomain, localhost, $mydomain" >> /etc/postfix/main.cf
echo "smtpd_sasl_auth_enable = yes" >> /etc/postfix/main.cf
echo "smtpd_sasl_type = cyrus" >> /etc/postfix/main.cf
echo "smtpd_sasl_security_options = noanonymous" >> /etc/postfix/main.cf
echo "broken_sasl_auth_clients = yes" >> /etc/postfix/main.cf
echo "smtpd_sasl_authenticated_header = yes" >> /etc/postfix/main.cf
echo "smtpd_recipient_restrictions = permit_sasl_authenticated,permit_mynetworks,reject_unauth_destination" >> /etc/postfix/main.cf
echo "smtpd_tls_auth_only = no" >> /etc/postfix/main.cf
echo "smtp_use_tls = yes" >> /etc/postfix/main.cf
echo "smtpd_use_tls = yes" >> /etc/postfix/main.cf
echo "smtp_tls_note_starttls_offer = yes" >> /etc/postfix/main.cf
echo "smtpd_tls_key_file = /etc/postfix/ssl/smtpd.key" >> /etc/postfix/main.cf
echo "smtpd_tls_cert_file = /etc/postfix/ssl/smtpd.crt" >> /etc/postfix/main.cf
echo "smtpd_tls_CAfile = /etc/postfix/ssl/cacert.pem" >> /etc/postfix/main.cf
echo "smtpd_tls_received_header = yes" >> /etc/postfix/main.cf
echo "smtpd_tls_session_cache_timeout = 3600s" >> /etc/postfix/main.cf
echo "tls_random_source = dev:/dev/urandom" >> /etc/postfix/main.cf

echo "http://www.krizna.com/centos/setup-mail-server-in-centos-6/"
echo "step 5"
