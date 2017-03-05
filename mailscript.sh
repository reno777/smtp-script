!#/bin/bash
yum install ngrep iproute iptables iptables-services nano -y
mv /etc/postfix/main.cf /etc/postfix/main.cf.bak
mv /etc/dovecot/dovecot.conf /etc/dovecot/dovecot.conf.bak
touch /etc/postfix/main.cf
touch /etc/dovecot/dovecot.conf

#postfix/main.conf
echo 'smptd banner = hostname.$mydomain mail server' >> /etc/postfix/main.cf
echo 'biff = no' >> /etc/postfix/main.cf
echo 'append_dot_mydomain = yes' >> /etc/postfix/main.cf
echo 'readme_directory = no' >> /etc/postfix/main.cf
echo 'smtpd_sasl_auth_enable = yes' >> /etc/postfix/main.cf
echo 'smtpd_sasl_path = private/auth' >> /etc/postfix/main.cf
echo 'smtpd_sasl_type = dovecot' >> /etc/postfix/main.cf
echo 'smtpd_recipient_restrictions = permit_mynetworks permit_sasl_authenticated reject_unauth_destination' >> /etc/postfix/main.cf
echo 'myhostname = mail' >> /etc/postfix/main.cf
echo 'mydomain = corp.australia.ists' >> /etc/postfix/main.cf
echo 'alias_maps = hash:/etc/aliases' >> /etc/postfix/main.cf
echo 'alias_database = hash:/etc/aliases' >> /etc/postfix/main.cf
echo 'myorigin = /etc/mailname' >> /etc/postfix/main.cf
echo 'mydestination = mail.$mydomain, $mydomain, localhost.localdomain, localhost' >> /etc/postfix/main.cf
echo 'relayhost = ' >> /etc/postfix/main.cf
echo 'mynetworks = 127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128' >> /etc/postfix/main.cf
echo 'mailbox_size_limit = 0' >> /etc/postfix/main.cf
echo 'recipient_delimiter = +' >> /etc/postfix/main.cf
echo 'inet_interfaces = all' >> /etc/postfix/main.cf
echo 'inet_protocols = all' >> /etc/postfix/main.cf

#dovecot/dovecot.conf
echo 'disable_plaintext_auth = no' >> /etc/dovecot/dovecot.conf
echo 'mail_privileged_group = mail' >> /etc/dovecot/dovecot.conf
echo 'mail_location = mbox:~/mail:INBOX=/var/mail/%u' >> /etc/dovecot/dovecot.conf
echo 'auth_mechanisms = plain login' >> /etc/dovecot/dovecot.conf
echo 'userdb {' >> /etc/dovecot/dovecot.conf
echo '    driver = passwd' >> /etc/dovecot/dovecot.conf
echo '}' >> /etc/dovecot/dovecot.conf
echo 'passdb {' >> /etc/dovecot/dovecot.conf
echo '    driver = pam' >> /etc/dovecot/dovecot.conf
echo '}' >> /etc/dovecot/dovecot.conf
echo 'protocols = imap pop3' >> /etc/dovecot/dovecot.conf
echo 'protocol imap {' >> /etc/dovecot/dovecot.conf
echo '    mail_plugins = " autocreate"' >> /etc/dovecot/dovecot.conf
echo '}' >> /etc/dovecot/dovecot.conf
echo 'plugin {' >> /etc/dovecot/dovecot.conf
echo '    autocreate = Trash' >> /etc/dovecot/dovecot.conf
echo '    autocreate2 = Sent' >> /etc/dovecot/dovecot.conf
echo '    autosubscribe = Trash' >> /etc/dovecot/dovecot.conf
echo '    autosubscribe2 = Sent' >> /etc/dovecot/dovecot.conf
echo '}' >> /etc/dovecot/dovecot.conf
echo 'service auth {' >> /etc/dovecot/dovecot.conf
echo '    unix_listener /var/spool/postfix/private/auth {' >> /etc/dovecot/dovecot.conf
echo '        group = postfix' >> /etc/dovecot/dovecot.conf
echo '        mode = 0660' >> /etc/dovecot/dovecot.conf
echo '        user = postfix' >> /etc/dovecot/dovecot.conf
echo '    }' >> /etc/dovecot/dovecot.conf
echo '}' >> /etc/dovecot/dovecot.conf
echo 'ssl = no' >> /etc/dovecot/dovecot.conf

systemctl stop firewalld
systemctl disable firewalld
systemctl enable iptables
systemctl restart iptables
systemctl status iptables
sleep 5

#iptables
mv /etc/sysconfig/itpables /etc/sysconfig/iptables.bak
touch /etc/sysconfig/iptables

echo ':INPUT DROP [0:0]' >> /etc/sysconfig/iptables
echo ':FORWARD DROP [0:0]' >> /etc/sysconfig/iptables
echo ':OUTPUT ACCEPT [0:0]' >> /etc/sysconfig/iptables
echo '-A INPUT -m state --state ESTABLSIHED,RELATED -j ACCEPT' >> /etc/sysconfig/iptables
echo '-A INPUT -m state --state NEW -m tcp -p tcp --dport 25 -j ACCEPT' >> /etc/sysconfig/iptables
echo '-A INPUT -m state --state NEW -m tcp -p tcp --dport 143 -j ACCEPT' >> /etc/sysconfig/iptables
echo '-A INPUT -j REJECT' >> /etc/sysconfig/iptables
echo 'COMMIT' >> /etc/sysconfig/iptables

#systemctl stop firewalld
#systemctl disable firewalld
#systemctl enable iptables
#systemctl restart iptables
#systemctl status iptables
#sleep 5

#chkconfig/network
chkconfig network on
systemctl restart network
sleep 5

#end
ngrep -d any port 25
