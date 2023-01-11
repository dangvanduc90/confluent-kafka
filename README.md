[Docs confluent kafka](https://docs.confluent.io/platform/current/installation/installing_cp/rhel-centos.html#install-cp-using-systemd-on-rhel-and-centos)

vagrant multi broken

1. install vagrant
2. `vagrant up`
3. add these line to `/etc/hosts` in host machine
```
192.168.204.156 zoo1 kafka1
192.168.204.157 zoo2 kafka2
192.168.204.158 zoo3 kafka3
```
4. `vagrant ssh zoo1`
   1. `sudo systemctl status confluent*`
   2. verify these service status is running
   3. for check log `sudo journalctl -f -u confluent-kafka` and `sudo journalctl -f -u confluent-zookeeper`
5. repeat after step 4, for `zoo2` and `zoo3`
