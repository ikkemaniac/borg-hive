#!/usr/bin/env bash

ssh-keygen -A

for key in $(echo "ssh_host_rsa_key ssh_host_ecdsa_key ssh_host_ed25519_key")
do
if [[ ! -f /config/${key} ]]; then
  echo "Copy /etc/ssh/${key} to /config/${key}"
  cp /etc/ssh/${key} /config/${key}
  cp /etc/ssh/${key}.pub /config/${key}.pub
fi
done

# make repos accessible for borg user
setfacl -R -d -m u:borg:rwx /repos

# set ldap config
cat <<EOF >> /etc/nslcd.conf
uid nslcd
gid nslcd

# The location at which the LDAP server(s) should be reachable.
uri $BORG_LDAP_HOST

# The search base that will be used for all queries.
base $BORG_LDAP_BASE_DN

# The LDAP protocol version to use.
#ldap_version 3

# The DN to bind with for normal lookups.
binddn $BORG_LDAP_READONLY_DN
bindpw $BORG_LDAP_READONLY_USER_PASSWORD

# SSL options
#ssl off
#tls_reqcert never
tls_cacertfile /etc/ssl/certs/ca-certificates.crt
EOF

# start nslcd
nslcd

# -D in CMD below prevents sshd from becoming a daemon. -e is to log everything to stderr.
/usr/sbin/sshd -D -e
