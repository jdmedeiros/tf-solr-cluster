#!/bin/bash -x

SCRIPT_LOG_DETAIL=/var/log/cloud-config-detail.log
ZOOKEEPERS="172.16.0.21:2181,172.16.0.22:2181,172.16.0.23:2181"

exec 3>&1 4>&2                  #
trap 'exec 2>&4 1>&3' 0 1 2 3   # https://serverfault.com/questions/103501/how-can-i-fully-log-all-bash-scripts-actions
exec 1>$SCRIPT_LOG_DETAIL 2>&1  #

yum -y update

sudo amazon-linux-extras install -y java-openjdk11 && sudo yum -y install java-11-openjdk-devel
echo JAVA_HOME "/usr/" >> /etc/profile.d/java.cshsetenv
echo JAVA_HOME=/usr/ >> /etc/profile.d/java.shexport
cd /opt
wget https://archive.apache.org/dist/lucene/solr/8.11.1/solr-8.11.1.tgz
tar xzf solr-8.11.1.tgz solr-8.11.1/bin/install_solr_service.sh --strip-components=2
/opt/install_solr_service.sh solr-8.11.1.tgz -i /opt -d /var/solr -u solr -s solr -p 8983
sed -i 's|#ZK_HOST=""|ZK_HOST="'"$ZOOKEEPERS"'/spot-solr"|g' /etc/default/solr.in.sh
chmod ugo+x /etc/default/solr.in.sh
systemctl enable --now solr
service solr restart
/opt/solr/bin/solr zk mkroot /spot-solr -z "$ZOOKEEPERS"
service solr restart