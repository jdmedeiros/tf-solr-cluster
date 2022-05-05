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
sed -i 's|#ZK_HOST=""|ZK_HOST="'"${ZOOKEEPERS}"'/solr_v1"|g' /etc/default/solr.in.sh
systemctl enable --now solr
service solr restart
/opt/solr/bin/solr zk mkroot /solr_v1 -z "${ZOOKEEPERS}"

logger Critical time $(date '+%Y%m%d%H')
SECRET=$(date '+%Y%m%d%H' |md5sum | awk '{print $1}')
LOCALIP=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)

cd /opt/solr/server/etc

keytool -genkeypair -alias solr-ssl -keyalg RSA -keysize 2048 -keypass "${SECRET}" -storepass "${SECRET}" -validity 9999 -keystore solr-ssl.keystore.p12 -storetype PKCS12 -ext SAN=DNS:localhost,IP:"${LOCALIP}",IP:127.0.0.1 -dname "CN=localhost, OU=Departamento de Informatica, O=ENTA, L=Ponta Delgada, ST=Azores, C=Portugal"

openssl pkcs12 -in solr-ssl.keystore.p12 -out solr-ssl.pem -passin pass:"${SECRET}" -passout pass:"${SECRET}"

sed -i 's|#SOLR_SSL_ENABLED=true|SOLR_SSL_ENABLED=true|g' /etc/default/solr.in.sh
sed -i 's|#SOLR_SSL_KEY_STORE=etc/solr-ssl.keystore.p12|SOLR_SSL_KEY_STORE=etc/solr-ssl.keystore.p12|g' /etc/default/solr.in.sh
sed -i 's|#SOLR_SSL_KEY_STORE_PASSWORD=secret|SOLR_SSL_KEY_STORE_PASSWORD='"${SECRET}"'|g' /etc/default/solr.in.sh
sed -i 's|#SOLR_SSL_TRUST_STORE=etc/solr-ssl.keystore.p12|SOLR_SSL_TRUST_STORE=etc/solr-ssl.keystore.p12|g' /etc/default/solr.in.sh
sed -i 's|#SOLR_SSL_TRUST_STORE_PASSWORD=secret|SOLR_SSL_TRUST_STORE_PASSWORD='"${SECRET}"'|g' /etc/default/solr.in.sh
sed -i 's|#SOLR_SSL_NEED_CLIENT_AUTH=false|SOLR_SSL_NEED_CLIENT_AUTH=false|g' /etc/default/solr.in.sh
sed -i 's|#SOLR_SSL_WANT_CLIENT_AUTH=false|SOLR_SSL_WANT_CLIENT_AUTH=false|g' /etc/default/solr.in.sh
sed -i 's|#SOLR_SSL_CHECK_PEER_NAME=true|SOLR_SSL_CHECK_PEER_NAME=true|g' /etc/default/solr.in.sh

chmod ugo+x /opt/solr/server/scripts/cloud-scripts/zkcli.sh
chmod ugo+x /etc/default/solr.in.sh
sed -i /etc/default/solr.in.sh -re 's/^#?SOLR_AUTH_TYPE=.*/SOLR_AUTH_TYPE="basic"/; s/^#?SOLR_AUTHENTICATION_OPTS=.*/SOLR_AUTHENTICATION_OPTS="-Dbasicauth=admin:'"${SECRET}"'"/'
service solr restart
/opt/solr/server/scripts/cloud-scripts/zkcli.sh -zkhost "${ZOOKEEPERS}"/solr_v1 -cmd clusterprop -name urlScheme -val https
/opt/solr/bin/solr auth enable -type basicAuth -prompt true -z "${ZOOKEEPERS}"/solr_v1 -blockUnknown true -credentials admin:"${SECRET}"