#!/bin/sh
#
# Run the puppet agent on all our ops machines 

PUPPETAGENT="\"/usr/bin/sudo /usr/bin/puppet agent -t\""
MYSELF="rmagahiz"
SSH="ssh -t"
TODAY=`date +%F`

echo "=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+"
# nagios
HOST=nagios
$SSH $MYSELF@$HOST.ops.daqri.com "sudo tar czf /tmp/$HOST.$TODAY.tgz /etc/nagios3/" || echo $HOST
scp $MYSELF@$HOST.ops.daqri.com:/tmp/$HOST.$TODAY.tgz ~/Ops/richnotes/config && ssh $MYSELF@$HOST.ops.daqri.com "sudo rm /tmp/$HOST.$TODAY.tgz"

echo "=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+"
# metrics
HOST=metrics
$SSH $MYSELF@$HOST.ops.daqri.com "sudo tar czf /tmp/$HOST.$TODAY.tgz /etc/uwsgi/ /usr/share/uwsgi/conf" || echo $HOST
scp $MYSELF@$HOST.ops.daqri.com:/tmp/$HOST.$TODAY.tgz ~/Ops/richnotes/config && ssh $MYSELF@$HOST.ops.daqri.com "sudo rm /tmp/$HOST.$TODAY.tgz"

echo "=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+"
# puppet-master
HOST=puppet-master
$SSH $MYSELF@$HOST.ops.daqri.com "sudo tar czf /tmp/$HOST.$TODAY.tgz /etc/puppet/fileserver.conf /etc/nginx/nginx.conf " || echo $HOST
scp $MYSELF@$HOST.ops.daqri.com:/tmp/$HOST.$TODAY.tgz ~/Ops/richnotes/config && ssh $MYSELF@$HOST.ops.daqri.com "sudo rm /tmp/$HOST.$TODAY.tgz"

echo "=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+"
# repository
HOST=repository
$SSH $MYSELF@$HOST.ops.daqri.com "sudo tar czf /tmp/$HOST.$TODAY.tgz /etc/nginx/nginx.conf " || echo $HOST
scp $MYSELF@$HOST.ops.daqri.com:/tmp/$HOST.$TODAY.tgz ~/Ops/richnotes/config && ssh $MYSELF@$HOST.ops.daqri.com "sudo rm /tmp/$HOST.$TODAY.tgz"

echo "=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+"
# jenkins-slave1
HOST=jenkins-slave1
$SSH $MYSELF@$HOST.dev.daqri.com "sudo tar czf /tmp/$HOST.$TODAY.tgz /etc/mongodb.conf /etc/postgresql/9.3/main /var/lib/jenkins/config.xml  /etc/mysql" || echo $HOST
scp $MYSELF@$HOST.dev.daqri.com:/tmp/$HOST.$TODAY.tgz ~/Ops/richnotes/config && ssh $MYSELF@$HOST.dev.daqri.com "sudo rm /tmp/$HOST.$TODAY.tgz"

echo "=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+"
# jenkins-slave2
HOST=jenkins-slave2
$SSH $MYSELF@$HOST.dev.daqri.com "sudo tar czf /tmp/$HOST.$TODAY.tgz /etc/mongodb.conf /etc/postgresql/9.3/main /var/lib/jenkins/config.xml /etc/mysql" || echo $HOST
scp $MYSELF@$HOST.dev.daqri.com:/tmp/$HOST.$TODAY.tgz ~/Ops/richnotes/config && ssh $MYSELF@$HOST.dev.daqri.com "sudo rm /tmp/$HOST.$TODAY.tgz"

echo "=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+"
# jenkins-slave3
HOST=jenkins-slave3
$SSH $MYSELF@$HOST.dev.daqri.com "sudo tar czf /tmp/$HOST.$TODAY.tgz /etc/mongodb.conf /etc/postgresql/9.3/main /var/lib/jenkins/config.xml  /etc/mysql" || echo $HOST
scp $MYSELF@$HOST.dev.daqri.com:/tmp/$HOST.$TODAY.tgz ~/Ops/richnotes/config && ssh $MYSELF@$HOST.dev.daqri.com "sudo rm /tmp/$HOST.$TODAY.tgz"

echo "=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+"
# ops-builder
HOST=ops-builder
$SSH $MYSELF@$HOST.ops.daqri.com "sudo tar czf /tmp/$HOST.$TODAY.tgz /etc/memcached.conf /var/lib/jenkins/users /var/lib/jenkins/jobs/Operations/config.xml /var/lib/jenkins/secrets" || echo $HOST
scp $MYSELF@$HOST.ops.daqri.com:/tmp/$HOST.$TODAY.tgz ~/Ops/richnotes/config && ssh $MYSELF@$HOST.ops.daqri.com "sudo rm /tmp/$HOST.$TODAY.tgz"

echo "=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+"
# app-jenkins
HOST=app-jenkins
$SSH $MYSELF@$HOST.dev.daqri.com "sudo tar czf /tmp/$HOST.$TODAY.tgz /etc/nginx/conf.d/ /etc/nginx/nginx.conf /etc/mongodb.conf /etc/postgres /var/lib/jenkins/users /var/lib/jenkins/jobs/*/config.xml /var/lib/jenkins/secrets" || echo $HOST
scp $MYSELF@$HOST.dev.daqri.com:/tmp/$HOST.$TODAY.tgz ~/Ops/richnotes/config && ssh $MYSELF@$HOST.dev.daqri.com "sudo rm /tmp/$HOST.$TODAY.tgz"
