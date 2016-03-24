/etc/default/mesos-master:
  file.append:
    - text: CLUSTER="MesosLabs"
    - require:
      - pkg: mesos

/etc/hosts:
  file.managed:
    - source: salt://hosts

/etc/mesos/zk:
  file.managed:
    - source: salt://zk
    - require:
      - pkg: mesos 

/etc/mesos/mesos-dns.json:
  file.managed:
    - source: salt://mesos-dns.json

/etc/zookeeper/conf/zoo.cfg:
  file.append:
    - text:
      - server.1=192.168.33.20:2888:3888
      - server.2=192.168.33.21:2888:3888
      - server.3=192.168.33.22:2888:3888
    - require:
      - pkg: zookeeper

/etc/mesos-master/quorum:
  file.managed:
    - source: salt://quorum
    - require:
      - pkg: mesos

/home/vagrant/build_dns.sh:
  file.managed:
    - source: salt://build_dns.sh
    - mode: 755
    - user: vagrant
    - group: vagrant

/etc/resolv.conf:
  file.managed:
    - source: salt://resolv.conf

chattr_resolv:
  cmd.run:
    - name: /srv/salt/resolv.sh 
    - user: root 
    - group: root 
    - require:
      - file: /etc/resolv.conf 
    - watch:
      - file: /etc/resolv.conf

zoo_rpm:
  cmd:
    - run
    - name: rpm -Uvh http://archive.cloudera.com/cdh4/one-click-install/redhat/6/x86_64/cloudera-cdh-4-0.x86_64.rpm

mesos_rpm:
  cmd:
    - run
    - name: rpm -Uvh http://repos.mesosphere.com/el/7/noarch/RPMS/mesosphere-el-repo-7-1.noarch.rpm

zoo_srv_init:
  cmd:
    - run
    - name: sudo -u zookeeper zookeeper-server-initialize --myid=`echo $HOSTNAME | grep -o '[0-9]*'`
    - require:
      - pkg: zookeeper-server

zoo_srv_start:
  cmd:
    - run
    - name: service zookeeper-server start
    - require:
      - pkg: zookeeper-server
      - cmd: zoo_srv_init
    - watch:
      - cmd: zoo_srv_init
    - order: last

zookeeper:
  pkg:
    - installed
    - require:
      - cmd: zoo_rpm

zookeeper-server:
  pkg:
    - installed
    - require:
      - cmd: zoo_rpm

mesos:
  pkg:
    - installed
    - require:
      - pkg: zookeeper-server
      - pkg: zookeeper
      - cmd: mesos_rpm

mesos-master:
  service.running:
    - enable: True
    - require:
      - pkg: mesos 
    - watch:
      - cmd: zoo_srv_start

mesos-slave:
  service.running:
    - enable: True
    - require:
      - pkg: mesos
    - watch:
      - cmd: zoo_srv_start

marathon:
  pkg:
    - installed
  service.running:
    - require:
      - pkg: mesos

chronos:
  pkg:
    - installed
  service.running:
    - require:
      - pkg: mesos

golang:
  pkg:
    - installed

git:
  pkg:
    - installed

bind-utils:
  pkg:
    - installed

build_dns:
  cmd.run:
    - name: /home/vagrant/build_dns.sh 
    - cwd: /home/vagrant
    - user: vagrant
    - group: vagrant
    - require:
      - pkg: golang
      - pkg: git 
      - pkg: bind-utils
      - file: /home/vagrant/build_dns.sh

 
