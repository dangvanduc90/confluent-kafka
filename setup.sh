#!/bin/bash
sudo yum install -y curl which
sudo rpm --import https://packages.confluent.io/rpm/7.3/archive.key
sudo yum install -y epel-release ansible java-1.8.0-openjdk.x86_64



sudo cat <<'EOF' | sudo tee /etc/yum.repos.d/confluent.repo
[Confluent]
name=Confluent repository
baseurl=https://packages.confluent.io/rpm/7.3
gpgcheck=1
gpgkey=https://packages.confluent.io/rpm/7.3/archive.key
enabled=1

[Confluent-Clients]
name=Confluent Clients repository
baseurl=https://packages.confluent.io/clients/rpm/centos/$releasever/$basearch
gpgcheck=1
gpgkey=https://packages.confluent.io/clients/rpm/archive.key
enabled=1
EOF

sudo yum clean all &&  sudo yum install -y confluent-community-2.13

_HOSTNAME=$1
echo "_HOSTNAME: ${_HOSTNAME}"




if [ -n "${_HOSTNAME}" ] && [ "${_HOSTNAME}" == 'zoo1' ]; then
sudo cat <<EOF | sudo tee /etc/kafka/zookeeper.properties
tickTime=2000
dataDir=/var/lib/zookeeper/
clientPort=2181
initLimit=5
syncLimit=2
server.1=0.0.0.0:2888:3888
server.2=zoo2:2888:3888
server.3=zoo3:2888:3888
autopurge.snapRetainCount=3
autopurge.purgeInterval=24
EOF

sudo cat <<EOF | sudo tee  /etc/kafka/server.properties
broker.id.generation.enable=true
listeners=PLAINTEXT://:9092
advertised.listeners=PLAINTEXT://kafka1:9092
num.network.threads=3
num.io.threads=8
socket.send.buffer.bytes=102400
socket.receive.buffer.bytes=102400
socket.request.max.bytes=104857600
log.dirs=/var/lib/kafka
num.partitions=1
num.recovery.threads.per.data.dir=1
offsets.topic.replication.factor=1
transaction.state.log.replication.factor=1
transaction.state.log.min.isr=1
log.retention.hours=168
log.retention.check.interval.ms=300000
zookeeper.connect=zoo1:2181,zoo2:2181,zoo3:2181
zookeeper.connection.timeout.ms=18000
group.initial.rebalance.delay.ms=0
EOF

echo "192.168.204.157   zoo2" >> /etc/hosts
echo "192.168.204.158   zoo3" >> /etc/hosts
echo "127.0.0.1   kafka1" >> /etc/hosts
sudo touch /var/lib/zookeeper/myid
echo "1" >> /var/lib/zookeeper/myid
fi





if [ -n "${_HOSTNAME}" ] && [ "${_HOSTNAME}" == 'zoo2' ]; then
sudo cat <<EOF | sudo tee /etc/kafka/zookeeper.properties
tickTime=2000
dataDir=/var/lib/zookeeper/
clientPort=2181
initLimit=5
syncLimit=2
server.1=zoo1:2888:3888
server.2=0.0.0.0:2888:3888
server.3=zoo3:2888:3888
autopurge.snapRetainCount=3
autopurge.purgeInterval=24
EOF

sudo cat <<EOF | sudo tee  /etc/kafka/server.properties
broker.id.generation.enable=true
listeners=PLAINTEXT://:9092
advertised.listeners=PLAINTEXT://kafka2:9092
num.network.threads=3
num.io.threads=8
socket.send.buffer.bytes=102400
socket.receive.buffer.bytes=102400
socket.request.max.bytes=104857600
log.dirs=/var/lib/kafka
num.partitions=1
num.recovery.threads.per.data.dir=1
offsets.topic.replication.factor=1
transaction.state.log.replication.factor=1
transaction.state.log.min.isr=1
log.retention.hours=168
log.retention.check.interval.ms=300000
zookeeper.connect=zoo1:2181,zoo2:2181,zoo3:2181
zookeeper.connection.timeout.ms=18000
group.initial.rebalance.delay.ms=0
EOF

echo "192.168.204.156   zoo1" >> /etc/hosts
echo "192.168.204.158   zoo3" >> /etc/hosts
echo "127.0.0.1   kafka2" >> /etc/hosts
sudo touch /var/lib/zookeeper/myid
echo "2" >> /var/lib/zookeeper/myid
fi




if [ -n "${_HOSTNAME}" ] && [ "${_HOSTNAME}" == 'zoo3' ]; then
sudo cat <<EOF | sudo tee /etc/kafka/zookeeper.properties
tickTime=2000
dataDir=/var/lib/zookeeper/
clientPort=2181
initLimit=5
syncLimit=2
server.1=zoo1:2888:3888
server.2=zoo2:2888:3888
server.3=0.0.0.0:2888:3888
autopurge.snapRetainCount=3
autopurge.purgeInterval=24
EOF

sudo cat <<EOF | sudo tee  /etc/kafka/server.properties
broker.id.generation.enable=true
listeners=PLAINTEXT://:9092
advertised.listeners=PLAINTEXT://kafka3:9092
num.network.threads=3
num.io.threads=8
socket.send.buffer.bytes=102400
socket.receive.buffer.bytes=102400
socket.request.max.bytes=104857600
log.dirs=/var/lib/kafka
num.partitions=1
num.recovery.threads.per.data.dir=1
offsets.topic.replication.factor=1
transaction.state.log.replication.factor=1
transaction.state.log.min.isr=1
log.retention.hours=168
log.retention.check.interval.ms=300000
zookeeper.connect=zoo1:2181,zoo2:2181,zoo3:2181
zookeeper.connection.timeout.ms=18000
group.initial.rebalance.delay.ms=0
EOF

echo "192.168.204.156   zoo1" >> /etc/hosts
echo "192.168.204.157   zoo2" >> /etc/hosts
echo "127.0.0.1   kafka3" >> /etc/hosts
sudo touch /var/lib/zookeeper/myid
echo "3" >> /var/lib/zookeeper/myid
fi

#sed -i 's/zookeeper.connect=localhost:2181/zookeeper.connect=zoo1:2181,zoo3:2181,zoo3:2181/g' /etc/kafka/server.properties
#sed -i 's/broker.id=0/broker.id.generation.enable=true/g' /etc/kafka/server.properties



sudo firewall-cmd --zone=public --add-port=9092/tcp --permanent
sudo firewall-cmd --zone=public --add-port=2888/tcp --permanent
sudo firewall-cmd --zone=public --add-port=2181/tcp --permanent
sudo firewall-cmd --reload

sudo systemctl start confluent-zookeeper
sleep 30
sudo systemctl start confluent-kafka
sudo systemctl enable confluent-zookeeper
sudo systemctl enable confluent-kafka

# add these line to /etc/hosts in host machine
#192.168.204.156 zoo1 kafka1
#192.168.204.157 zoo2 kafka2
#192.168.204.158 zoo3 kafka3